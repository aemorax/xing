package xing.template;

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

interface AnalyzerDriver {
	private function handleStatement(statement:Statement):Array<XingCode>;
	private function handleBlockStatement(statement:BlockStatement):Array<XingCode>;
	private function handleExpressionStatement(statement:ExpressionStatement):Array<XingCode>;
	private function handleIfStatement(statement:IfStatement):Array<XingCode>;
	private function handleWhileStatement(statement:WhileStatement):Array<XingCode>;
	private function handleForStatement(statement:ForStatement):Array<XingCode>;
	private function handleDocStatement(statement:DocStatement):Array<XingCode>;

	private function handleExpression(expression:Expression):XingCode;
	private function handlePrefixUnaryExpression(expression:UnaryPrefixExpression):XingCode;
	private function handlePostfixUnaryExpression(expression:UnaryPostExpression):XingCode;
	private function handleBinaryExpression(expression:BinaryExpression):XingCode;
	private function handleGroupExpression(expression:GroupExpression):XingCode;
	private function handleLiteralExpression(expression:LiteralExpression):XingCode;
	private function handleVariableExpression(expression:VariableExpression):XingCode;
	private function handleAssignmentExpression(expression:AssignmentExpression):XingCode;
	private function handleIteratorExpression(expression:IteratorExpression):XingCode;
	private function handleForConditionExpression(expression:ForConditionExpression):XingCode;
}
