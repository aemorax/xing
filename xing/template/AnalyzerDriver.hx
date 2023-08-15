package xing.template;

import xing.template.Statement.TemplateStatement;
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

typedef ForConditionCode = {
	var ?init : Array<XingCode>;
	var ?cond : Array<XingCode>;
	var ?step : Array<XingCode>;
}

interface AnalyzerDriver {
	private function handleStatement(statement:Statement):Array<XingCode>;
	private function handleBlockStatement(statement:BlockStatement):Array<XingCode>;
	private function handleExpressionStatement(statement:ExpressionStatement):Array<XingCode>;
	private function handleIfStatement(statement:IfStatement):Array<XingCode>;
	private function handleWhileStatement(statement:WhileStatement):Array<XingCode>;
	private function handleForStatement(statement:ForStatement):Array<XingCode>;
	private function handleDocStatement(statement:DocStatement):Array<XingCode>;
	private function handleTemplateStatement(statement:TemplateStatement):Array<XingCode>;

	private function handleExpression(expression:Expression):Array<XingCode>;
	private function handlePrefixUnaryExpression(expression:UnaryPrefixExpression):Array<XingCode>;
	private function handlePostfixUnaryExpression(expression:UnaryPostExpression):Array<XingCode>;
	private function handleBinaryExpression(expression:BinaryExpression):Array<XingCode>;
	private function handleGroupExpression(expression:GroupExpression):Array<XingCode>;
	private function handleLiteralExpression(expression:LiteralExpression):Array<XingCode>;
	private function handleVariableExpression(expression:VariableExpression):Array<XingCode>;
	private function handleAssignmentExpression(expression:AssignmentExpression):Array<XingCode>;
	private function handleIteratorExpression(expression:IteratorExpression):Array<XingCode>;
	private function handleForConditionExpression(expression:ForConditionExpression):ForConditionCode;
}
