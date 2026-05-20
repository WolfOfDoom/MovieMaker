import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _db = FirebaseFirestore.instance;
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _directorController = TextEditingController();
  final _genreController = TextEditingController();
  final _synopsisController = TextEditingController();
  final _imageController = TextEditingController();

  void _addMovie() async {
    if (_titleController.text.isEmpty || _yearController.text.isEmpty) return;

    final newMovie = Movie(
      id: '',
      title: _titleController.text.trim(),
      year: int.parse(_yearController.text.trim()),
      director: _directorController.text.trim(),
      genre: _genreController.text.trim(),
      synopsis: _synopsisController.text.trim(),
      imageUrl: _imageController.text.trim().isEmpty
          ? 'https://via.placeholder.com/150'
          : _imageController.text.trim(),
    );

    await _db.collection('movies').add(newMovie.toFirestore());

    // Limpiar campos
    _titleController.clear();
    _yearController.clear();
    _directorController.clear();
    _genreController.clear();
    _synopsisController.clear();
    _imageController.clear();

    if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Película añadida con éxito')),
      );
  }

  void _deleteMovie(String id) async {
    await _db.collection('movies').doc(id).delete();
    if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Película dada de baja')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Alta de Película',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextField(
                        controller: _yearController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Año',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextField(
                        controller: _directorController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Director',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextField(
                        controller: _genreController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Género',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextField(
                        controller: _synopsisController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Sinopsis',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextField(
                        controller: _imageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'URL de la Imagen',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _addMovie,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Guardar Película'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(color: Colors.amber),
          const Text(
            'Baja de Películas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            flex: 3,
            child: StreamBuilder(
              stream: _db.collection('movies').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    final doc = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(
                        doc['title'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        doc['director'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMovie(doc.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
