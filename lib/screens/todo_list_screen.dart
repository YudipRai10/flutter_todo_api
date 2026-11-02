import 'package:flutter/material.dart';
import 'package:flutter_api/models/todo.dart';
import 'package:flutter_api/screens/add_screen.dart';
import 'package:flutter_api/services/todo_api.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedTodos = await TodoApi.fetchTodos();
      setState(() {
        todos = fetchedTodos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load todos. Please try again.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchTodos,
            tooltip: 'Reload',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddScreen,
        icon: const Icon(Icons.add),
        label: const Text('Add Todo'),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: fetchTodos,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (todos.isEmpty) {
      return const Center(
        child: Text(
          'No todos found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchTodos,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: todos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = todos[index];
          final isDone = item.completed;

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isDone
                    ? Colors.green.withOpacity(0.3)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: ListTile(
              onTap: () => navigateToEditScreen(item),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: IconButton(
                icon: Icon(
                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isDone ? Colors.green : Colors.amber,
                  size: 28,
                ),
                onPressed: () => toggleTodoStatus(item),
                tooltip: isDone ? 'Mark as Pending' : 'Mark as Done',
              ),
              title: Text(
                item.todo,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? Colors.grey : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'User #${item.userId}  •  Todo #${item.id}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => toggleTodoStatus(item),
                        child: Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text(
                            isDone ? 'Done' : 'Pending',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDone
                                  ? Colors.greenAccent
                                  : Colors.amberAccent,
                            ),
                          ),
                          backgroundColor: isDone
                              ? Colors.green.withOpacity(0.15)
                              : Colors.amber.withOpacity(0.15),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.blueAccent,
                          size: 20,
                        ),
                        onPressed: () => navigateToEditScreen(item),
                        tooltip: 'Edit Todo',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        onPressed: () => deleteTodo(item.id),
                        tooltip: 'Delete Todo',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> toggleTodoStatus(Todo item) async {
    final newStatus = !item.completed;
    try {
      final updated = await TodoApi.updateTodo(
        id: item.id,
        completed: newStatus,
      );

      setState(() {
        final index = todos.indexWhere((t) => t.id == item.id);
        if (index != -1) {
          todos[index] = item.copyWith(completed: updated.completed);
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus ? 'Marked as completed!' : 'Marked as pending!',
          ),
          backgroundColor: newStatus ? Colors.green : Colors.amber.shade800,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> navigateToEditScreen(Todo item) async {
    final updatedTodo = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (context) => AddTodo(todo: item)),
    );

    if (updatedTodo != null) {
      setState(() {
        final index = todos.indexWhere((todo) => todo.id == item.id);
        if (index != -1) {
          todos[index] = updatedTodo;
        }
      });
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final success = await TodoApi.deleteTodo(id);
      if (success) {
        setState(() {
          todos.removeWhere((item) => item.id == id);
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Todo #$id deleted successfully'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> navigateToAddScreen() async {
    final newTodo = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(builder: (context) => const AddTodo()),
    );

    if (newTodo != null) {
      setState(() {
        todos.insert(0, newTodo);
      });
    }
  }
}
