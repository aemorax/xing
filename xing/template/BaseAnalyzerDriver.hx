package xing.template;

import xing.exception.template.AnalyzerException;
import xing.template.Expression.AssignmentExpression;
import xing.template.Expression.BinaryExpression;
import xing.template.Expression.ForConditionExpression;
import xing.template.Expression.GroupExpression;
import xing.template.Expression.IteratorExpression;
import xing.template.Expression.LiteralExpression;
import xing.template.Expression.UnaryPostExpression;
import xing.template.Expression.UnaryPrefixExpression;
import xing.template.Expression.VariableExpression;
import xing.template.Statement.BlockStatement;
import xing.template.Statement.DocStatement;
import xing.template.Statement.ExpressionStatement;
import xing.template.Statement.ForStatement;
import xing.template.Statement.IfStatement;
import xing.template.Statement.WhileStatement;

class BaseAnalyzerDriver implements AnalyzerDriver {
	function handleStatement(statement:Statement):Array<XingCode> {
		switch (statement.kind) {
			case SBlock:
				return handleBlockStatement(cast statement);
			case SDoc:
				return handleDocStatement(cast statement);
			case SExpression:
				return handleExpressionStatement(cast statement);
			case SFor:
				return handleForStatement(cast statement);
			case SWhile:
				return handleWhileStatement(cast statement);
			case SIf:
				return handleIfStatement(cast statement);
		}
	}

	function handleBlockStatement(statement:BlockStatement):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleExpressionStatement(statement:ExpressionStatement):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleIfStatement(statement:IfStatement):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleWhileStatement(statement:WhileStatement):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleForStatement(statement:ForStatement):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleDocStatement(statement:DocStatement):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleExpression(expression:Expression):Array<XingCode> {
		switch (expression.kind) {
			case ELiteral:
				return handleLiteralExpression(cast expression);
			case EVariable:
				return handleVariableExpression(cast expression);
			case EPrefixUnary:
				return handlePrefixUnaryExpression(cast expression);
			case EPostfixUnary:
				return handlePostfixUnaryExpression(cast expression);
			case EBinary:
				return handleBinaryExpression(cast expression);
			case EGroup:
				return handleGroupExpression(cast expression);
			case EAssignment:
				return handleAssignmentExpression(cast expression);
			case EPassAssignment:
				return handleAssignmentExpression(cast expression);
			case ECompAssignment:
				return handleAssignmentExpression(cast expression);
			case EForCondition:
				return handleForConditionExpression(cast expression);
			case EIterator:
				return handleForConditionExpression(cast expression);
		}

		throw new AnalyzerException("Expression kind is unknown.", expression);
	}

	function handlePrefixUnaryExpression(expression:UnaryPrefixExpression):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handlePostfixUnaryExpression(expression:UnaryPostExpression):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleBinaryExpression(expression:BinaryExpression):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleGroupExpression(expression:GroupExpression):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleLiteralExpression(expression:LiteralExpression):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleAssignmentExpression(expression:AssignmentExpression):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleIteratorExpression(expression:IteratorExpression):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleForConditionExpression(expression:ForConditionExpression):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleVariableExpression(expression:VariableExpression):Array<XingCode> {
		throw new haxe.exceptions.NotImplementedException();
	}
}
