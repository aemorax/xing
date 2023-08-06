package xing.template;

import xing.template.Expression.AssignmentExpression;
import xing.template.Expression.BinaryExpression;
import xing.template.Expression.ForConditionExpression;
import xing.template.Expression.GroupExpression;
import xing.template.Expression.IteratorExpression;
import xing.template.Expression.LiteralExpression;
import xing.template.Expression.UnaryPostExpression;
import xing.template.Expression.UnaryPrefixExpression;
import xing.template.Statement.BlockStatement;
import xing.template.Statement.DocStatement;
import xing.template.Statement.ExpressionStatement;
import xing.template.Statement.ForStatement;
import xing.template.Statement.IfStatement;
import xing.template.Statement.WhileStatement;

interface AnalyzerDriver {
	private function handleStatement(statement:Statement):Statement;
	private function handleBlockStatement(statement:BlockStatement):Statement;
	private function handleExpressionStatement(statement:ExpressionStatement):Statement;
	private function handleIfStatement(statement:IfStatement):Statement;
	private function handleWhileStatement(statement:WhileStatement):Statement;
	private function handleForStatement(statement:ForStatement):Statement;
	private function handleDocStatement(statement:DocStatement):Statement;

	private function handleExpression(expression:Expression):Expression;
	private function handlePrefixUnaryExpression(expression:UnaryPrefixExpression):Expression;
	private function handlePostfixUnaryExpression(expression:UnaryPostExpression):Expression;
	private function handleBinaryExpression(expression:BinaryExpression):Expression;
	private function handleGroupExpression(expression:GroupExpression):Expression;
	private function handleLiteralExpression(expression:LiteralExpression):Expression;
	private function handleAssignmentExpression(expression:AssignmentExpression):Expression;
	private function handleIteratorExpression(expression:IteratorExpression):Expression;
	private function handleForConditionExpression(expression:ForConditionExpression):Expression;
}
