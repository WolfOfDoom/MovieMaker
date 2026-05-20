import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moviemaker/models/movie_model.dart';
import 'package:moviemaker/screens/detail_screen.dart';
import 'package:moviemaker/screens/admin_screen.dart';
import 'package:moviemaker/screens/auth_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'MovieMaker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.amber),
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.amber, size: 28),
          onSelected: (value) {
            if (value == 'catalogo') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Ya te encuentras visualizando el Catálogo de Películas',
                  ),
                  backgroundColor: Colors.amber,
                ),
              );
            } else if (value == 'admin') {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (ctx) => const AdminScreen()));
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'catalogo',
              child: Row(
                children: [
                  Icon(Icons.movie, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    'Ver Catálogo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'admin',
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings, color: Colors.black),
                  SizedBox(width: 10),
                  Text('Administración'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Panel de Administración',
            icon: const Icon(Icons.admin_panel_settings, color: Colors.amber),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (ctx) => const AdminScreen())),
          ),
          IconButton(
            tooltip: 'Cerrar Sesión',
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const AuthScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No hay películas en el catálogo.\nVe al panel de administración para añadir una.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

          final movieDocs = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: movieDocs.length,
            itemBuilder: (ctx, index) {
              final movie = Movie.fromFirestore(
                movieDocs[index].data() as Map<String, dynamic>,
                movieDocs[index].id,
              );

              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => DetailScreen(movie: movie),
                  ),
                ),
                child: Card(
                  color: Colors.grey[900],
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          movie.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[800],
                                width: double.infinity,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 12.0,
                        ),
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
