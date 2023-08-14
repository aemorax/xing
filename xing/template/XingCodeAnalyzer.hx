package xing.template;

import xing.template.Expression.BinaryExpression;
import xing.template.Expression.VariableExpression;
import xing.template.Statement.BlockStatement;
import xing.template.Statement.DocStatement;
import xing.template.Statement.ExpressionStatement;
import xing.template.Statement.IfStatement;
import xing.template.Statement.WhileStatement;

class XingCodeAnalyzer extends BaseAnalyzerDriver {
	private var pc:Int = 0;

	public function new(ast:Statement) {
		var c = handleStatement(ast);

		for(each in c) {
			trace(each);
		}

	}

	override function handleBlockStatement(statement:BlockStatement):Array<XingCode> {
		var codes:Array<XingCode> = [];
		for (st in statement.statements) {
			var c = this.handleStatement(st);
			for (each in c) {
				codes.push(each);
			}
		}
		return codes;
	}

	override function handleDocStatement(statement:DocStatement):Array<XingCode> {
		var node:XingCode = {
			opcode: DOC,
			arg1: {Variable: statement.token.literal}
		};
		return [node];
	}

	override function handleWhileStatement(statement:WhileStatement):Array<XingCode> {
		var codes:Array<XingCode> = [];
		var body = handleStatement(statement.body);
		var condition = handleExpression(statement.condition);

		for(c in condition) {
			codes.push(c);
		}

		codes.push({
			opcode: JEQ,
			arg1: {Literal: true},
			arg2: {Special: Accum},
			arg3: {Address: Relative(body.length+1)}
		});

		for(c in body) {
			codes.push(c);
		}

		codes.push({
			opcode: JMP,
			arg1: {Address: Relative(-body.length-1-condition.length)}
		});
		return codes;
	}

	override function handleExpressionStatement(statement:ExpressionStatement):Array<XingCode> {
		var node = handleExpression(statement.expression);
		return node;
	}

	override function handleIfStatement(statement:IfStatement):Array<XingCode> {
		var codes:Array<XingCode> = [];

		var condition = handleExpression(statement.condition);
		var thenBlock = handleStatement(statement.thenBlock);
		var elseBlock : Array<XingCode> = [];
		if(statement.elseBlock != null)
			elseBlock = handleStatement(statement.elseBlock);

		for(c in condition) {
			codes.push(c);
		}

		var jumpToNext : Int = (elseBlock.length == 0) ? thenBlock.length+1 : thenBlock.length+2;
		codes.push({
			opcode: JEQ,
			arg1: {Literal: false},
			arg2: {Special: Accum},
			arg3: {Address: Relative(jumpToNext)}
		});

		for(c in thenBlock) {
			codes.push(c);
		}

		if(elseBlock.length != 0) {
			jumpToNext = elseBlock.length+1;
			codes.push({
				opcode: JMP,
				arg1: {Address: Relative(jumpToNext)}
			});

			for(c in elseBlock) {
				codes.push(c);
			}
		}

		return codes;
	}

	override function handleAssignmentExpression(expression:Expression):Array<XingCode> {
		var ret:Array<XingCode> = [];
		switch (expression.oper.code) {
			case TEqual:
				var assCode : XingCode;
				assCode = {
					opcode: MOV,
					arg2: {Variable: expression.name.literal}
				}
				if (expression.expr.kind != ELiteral) {
					for(c in handleExpression(expression.expr))
						ret.push(c);
					assCode.arg1 = {Special: Accum};
				} else {
					assCode.arg1 = {Literal: expression.expr.value};
				}
				ret.push(assCode);
				return ret;
			default:
		}
		return null;
	}

	override function handleBinaryExpression(expression:BinaryExpression):Array<XingCode> {
		var ret:Array<XingCode> = [];
		var self : XingCode = {
			opcode: NOP
		};
		switch (expression.oper.code) {
			case TPlus:
				self.opcode = ADD;
			case TMinus:
				self.opcode = SUB;
			case TAsterisk:
				self.opcode = MUL;
			case TSlash:
				self.opcode = DIV;
			case TPrcent:
				self.opcode = MOD;
			case TCaret:
				self.opcode = XOR;
			case TPipe:
				self.opcode = ORA;
			case TAmp:
				self.opcode = AND;
			case TALBrakBrak:
				self.opcode = SHL;
			case TARBrakBrak:
				self.opcode = SHR;
			case TDAmp:
				self.opcode = LGA;
			case TDPipe:
				self.opcode = LGO;
			case TDEqual:
				self.opcode = CEQ;
			case TNEqual:
				self.opcode = CNQ;
			case TALBrak:
				self.opcode = CLT;
			case TARBrak:
				self.opcode = CGT;
			case TALBrakEqual:
				self.opcode = CLTE;
			case TARBrakEqual:
				self.opcode = CGTE;
			default:
		}

		if (expression.left.kind != ELiteral) {
			for(c in handleExpression(expression.left)) {
				ret.push(c);
			}
			self.arg1 = {Special: Accum};
		} else {
			self.arg1 = {Literal: expression.left.value};
		}

		if (expression.right.kind != ELiteral) {
			for(c in handleExpression(expression.right)) {
				ret.push(c);
			}
			self.arg2 = {Special: Accum};
		} else {
			self.arg2 = {Literal: expression.right.value};
		}

		ret.push(self);

		return ret;
	}

	override function handleVariableExpression(expression:VariableExpression):Array<XingCode> {
		var code:XingCode = {
			opcode: LDA,
			arg1: {Variable: expression.name.literal}
		};

		return [code];
	}
}
