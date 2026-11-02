import 'package:flutter/material.dart';
import 'package:flutter_api/models/todo.dart';
import 'package:flutter_api/services/todo_api.dart';

class AddTodo extends StatefulWidget {
  final Todo? todo;

  const AddTodo({super.key, this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _todoController = TextEditingController();
  bool _isSubmitting = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      _todoController.text = todo.todo;
    }
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    final text = _todoController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a todo title'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final Todo resultTodo;
      if (isEdit) {
        resultTodo = await TodoApi.updateTodo(
          id: widget.todo!.id,
          todo: text,
          completed: widget.todo!.completed,
        );
      } else {
        resultTodo = await TodoApi.addTodo(
          todo: text,
          completed: false,
          userId: 5,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit ? 'Todo updated successfully!' : 'Todo added successfully!',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Return the updated/created Todo back to the list screen
      Navigator.pop(context, resultTodo);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Todo' : 'Add Todo')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          TextField(
            controller: _todoController,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: 'Todo Task',
              hintText: 'e.g. Finish reading chapter 3',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.task_alt),
            ),
            onSubmitted: (_) => _submitData(),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _submitData,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    isEdit ? 'Update Todo' : 'Save Todo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
