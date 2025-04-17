#include <stdlib.h>
#include <stdio.h>
#include <string.h>

// stack structure to check if the parentheses are balanced
// The stack is implemented using a dynamic array
typedef struct Stack {
    char *arr;
    int top;
    int capacity;
} Stack;

// Function to create a stack of given capacity
Stack* createStack(int capacity) {
    Stack* stack = (Stack*)malloc(sizeof(Stack));
    stack->capacity = capacity;
    stack->top = -1;
    stack->arr = (char*)malloc(stack->capacity * sizeof(char));
    return stack;
}

// Stack is full when top is equal to the last index
int isFull(Stack* stack) {
    return stack->top == stack->capacity - 1;
}

// Stack is empty when top is -1
int isEmpty(Stack* stack) {
    return stack->top == -1;
}

// Function to add an item to stack. It increases top by 1
void push(Stack* stack, char item) {
    if (isFull(stack)) {
        return;
    }
    stack->arr[++stack->top] = item;
}

// Function to remove an item from stack. It decreases top by 1
char pop(Stack* stack) {
    if (isEmpty(stack)) {
        return '\0'; // Return a null character if the stack is empty
    }
    return stack->arr[stack->top--];
}

// Function to return the top from stack without removing it
char peek(Stack* stack) {
    if (isEmpty(stack)) {
        return '\0'; // Return a null character if the stack is empty
    }
    return stack->arr[stack->top];
}

// Function to check if the parentheses are balanced
int areParenthesesBalanced(const char* expr) {
    Stack* stack = createStack(100); // Create a stack with a capacity of 100
    for (int i = 0; expr[i]; i++) {
        if (expr[i] == '(' || expr[i] == '{' || expr[i] == '[') {
            push(stack, expr[i]);
        } else if (expr[i] == ')' || expr[i] == '}' || expr[i] == ']') {
            if (isEmpty(stack)) {
                free(stack->arr);
                free(stack);
                return 0; // Unmatched closing parenthesis
            }
            char top = pop(stack);
            if ((expr[i] == ')' && top != '(') ||
                (expr[i] == '}' && top != '{') ||
                (expr[i] == ']' && top != '[')) {
                free(stack->arr);
                free(stack);
                return 0; // Mismatched parentheses
            }
        }
    }
    int balanced = isEmpty(stack); // Check if the stack is empty at the end
    free(stack->arr);
    free(stack);
    return balanced;
}

// Test the function
int main() {
    char* expr;
    char choice[2];
    int continueChecking = 1;
    
    // The expression is limited to 100 characters
    expr = (char*)malloc(100 * sizeof(char));
    if (expr == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    while (continueChecking) {
        // Ask the user to type an expression
        printf("Type an expression: ");
        
        // Read the expression from the user
        scanf("%99s", expr);
        
        printf("Expression: %s is %s\n", expr, areParenthesesBalanced(expr) ? "balanced" : "NOT balanced");
        
        printf("Do you want to try another expression? (y/n): ");
        scanf("%1s", choice);
        
        if (choice[0] != 'y' && choice[0] != 'Y') {
            continueChecking = 0;
        }
    }
    
    free(expr); // Free allocated memory
    return 0;
}