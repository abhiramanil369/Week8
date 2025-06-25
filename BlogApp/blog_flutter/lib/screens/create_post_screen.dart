import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/token_storage.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  bool _isSubmitting = false;
  String? _errorMessage;

  void _submitPost() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final token = await TokenStorage.getToken();
    if (token == null) {
      setState(() {
        _errorMessage = 'You must be logged in to create a post.';
        _isSubmitting = false;
      });
      return;
    }

    final success = await ApiService.createPost(_title, _content, token);
    if (success) {
      if (mounted) Navigator.pop(context); // Go back to post list
    } else {
      setState(() {
        _errorMessage = 'Failed to create post. Please try again.';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null) ...[
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value ?? '',
                validator: (value) => value!.isEmpty ? 'Title required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Content'),
                onSaved: (value) => _content = value ?? '',
                validator: (value) => value!.isEmpty ? 'Content required' : null,
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPost,
                child: _isSubmitting ? const CircularProgressIndicator() : const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}