package xing.template;

import xing.template.Expression.VariableExpression;
import xing.template.Statement.WhileStatement;
import xing.template.Expression.BinaryExpression;
import xing.template.Statement.ExpressionStatement;
import xing.template.Statement.DocStatement;
import xing.template.Statement.BlockStatement;

class XingCodeAnalyzer extends BaseAnalyzerDriver {
	private var pc:Int = 0;
	private final queue:Array<XingCode> = new Array();

	private final codeGen:Array<XingCode> = new Array();

	public function new(ast:Statement) {
		handleStatement(ast);
		for(each in codeGen) {
			trace(each);
		}
	}

	override function handleBlockStatement(statement:BlockStatement):Array<XingCode> {
		var codes:Array<XingCode> = [];
		for (st in statement.statements) {
			var c = this.handleStatement(st);
			for(each in c) {
				codes.push(each);
			}
		}
		return codes;
	}

	override function handleDocStatement(statement:DocStatement):Array<XingCode> {
		var node:XingCode = {
			opcode: DOC,
			arg1: { Variable: statement.token.literal }
		};
		codeGen.push(node);
		return [node];
	}

	override function handleWhileStatement(statement:WhileStatement):Array<XingCode> {
		var codes:Array<XingCode> = [];
		handleStatement(statement.body);
		queue.reverse();
		while(queue.length != 0) {
			codes.push(queue.pop());
		}
		
		var condition = handleExpression(statement.condition);

		while(queue.length != 0) {
			codes.push(queue.pop());
		}

		codes.push(condition);
		
		var jmp : XingCode = {
			opcode: JMP,
			arg1: {Address: Relative(codes.length)}
		};

		codes.push({
			opcode: CEQ,
			arg1: {Special: Accum},
			arg2: {Literal: true},
			arg3: {Address: Relative(-codes.length)}
		});
		
		codeGen.push(jmp);
		for(each in codes) {
			codeGen.push(each);
		}
		codes.insert(0, jmp);
		return codes;
	}

	override function handleExpressionStatement(statement:ExpressionStatement):Array<XingCode> {
		var node = handleExpression(statement.expression);
		queue.push(node);
		return [node];
	}

	override function handleAssignmentExpression(expression:Expression):XingCode {
		var ret:XingCode;
		switch (expression.oper.code) {
			case TEqual:
				ret = {
					opcode: MOV,
					arg2: {Variable: expression.name.literal}
				}
				if (expression.expr.kind != ELiteral) {
					queue.push(handleExpression(expression.expr));
					ret.arg1 = {Special: Accum};
				} else {
					ret.arg1 = {Literal: expression.expr.value};
				}
				return ret;
			case TPlusEqual:
				ret = {
					opcode: MOV,
					arg1: {Special: Accum},
					arg2: {Variable: expression.name.literal}
				}
				var comp : XingCode = {
					opcode: ADD,
					arg2: {Variable: expression.name.literal}
				}
				if(expression.expr.kind != ELiteral) {
					queue.push(handleExpression(expression.expr));
				} else {
					comp.arg1 = {Literal: expression.expr.value};
				}
				queue.push(comp);
				return ret;
			default:
		}
		return null;
	}

	override function handleBinaryExpression(expression:BinaryExpression):XingCode {
		var ret:XingCode = {
			opcode: NOP
		};
		switch (expression.oper.code) {
			case TPlus:
				ret.opcode = ADD;
			case TMinus:
				ret.opcode = SUB;
			case TAsterisk:
				ret.opcode = MUL;
			case TSlash:
				ret.opcode = DIV;
			case TPrcent:
				ret.opcode = MOD;
			case TCaret:
				ret.opcode = XOR;
			case TPipe:
				ret.opcode = ORA;
			case TAmp:
				ret.opcode = AND;
			case TALBrakBrak:
				ret.opcode = SHL;
			case TARBrakBrak:
				ret.opcode = SHR;
			case TDAmp:
				ret.opcode = LGA;
			case TDPipe:
				ret.opcode = LGO;
			case TDEqual:
				ret.opcode = CEQ;
			case TNEqual:
				ret.opcode = CNQ;
			case TALBrak:
				ret.opcode = CLT;
			case TARBrak:
				ret.opcode = CGT;
			case TALBrakEqual:
				ret.opcode = CLTE;
			case TARBrakEqual:
				ret.opcode = CGTE;
			default:
		}
		if(expression.left.kind != ELiteral) {
			queue.push(handleExpression(expression.left));
			ret.arg1 = {Special: Accum};
		} else {
			ret.arg1 = {Literal: expression.left.value};
		}

		if(expression.right.kind != ELiteral) {
			queue.push(handleExpression(expression.right));
			ret.arg2 = {Special: Accum};
		} else {
			ret.arg2 = {Literal: expression.right.value};
		}

		return ret;
	}

	override function handleVariableExpression(expression:VariableExpression):XingCode {
		var code : XingCode = {
			opcode: LDA,
			arg1: {Variable: expression.name.literal}
		};

		return code;
	}
}
