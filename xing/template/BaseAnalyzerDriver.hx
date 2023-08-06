package xing.template;

import xing.template.Statement.BlockStatement;
import xing.template.Statement.ExpressionStatement;
import xing.template.Statement.IfStatement;
import xing.template.Statement.WhileStatement;
import xing.template.Statement.ForStatement;
import xing.template.Statement.DocStatement;
import xing.template.Expression.UnaryPrefixExpression;
import xing.template.Expression.UnaryPostExpression;
import xing.template.Expression.BinaryExpression;
import xing.template.Expression.GroupExpression;
import xing.template.Expression.LiteralExpression;
import xing.template.Expression.AssignmentExpression;
import xing.template.Expression.IteratorExpression;
import xing.template.Expression.ForConditionExpression;

class BaseAnalyzerDriver implements AnalyzerDriver {
	function handleStatement(statement:Statement):Statement {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleBlockStatement(statement:BlockStatement):Statement {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleExpressionStatement(statement:ExpressionStatement):Statement {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleIfStatement(statement:IfStatement):Statement {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleWhileStatement(statement:WhileStatement):Statement {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleForStatement(statement:ForStatement):Statement {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleDocStatement(statement:DocStatement):Statement {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleExpression(expression:Expression):Expression {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handlePrefixUnaryExpression(expression:UnaryPrefixExpression):Expression {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handlePostfixUnaryExpression(expression:UnaryPostExpression):Expression {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleBinaryExpression(expression:BinaryExpression):Expression {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleGroupExpression(expression:GroupExpression):Expression {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleLiteralExpression(expression:LiteralExpression):Expression {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleAssignmentExpression(expression:AssignmentExpression):Expression {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleIteratorExpression(expression:IteratorExpression):Expression {
		throw new haxe.exceptions.NotImplementedException();
	}

	function handleForConditionExpression(expression:ForConditionExpression):Expression {
		throw new haxe.exceptions.NotImplementedException();
	}
}