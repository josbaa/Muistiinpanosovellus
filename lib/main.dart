import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeView();
        }

        return const LoginView();
      },
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _authErrorText(e);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Syota sahkoposti ja salasana.';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'Salasana on liian heikko (vähintään 6 merkkiä).';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (mounted) {
        _showMessage('Rekisterointi onnistui. Olet nyt kirjautunut sisaan.');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _authErrorText(e);
      });
      if (mounted) {
        _showMessage(_authErrorText(e));
      }
    } catch (_) {
      setState(() {
        _errorMessage = 'Rekisterointi epaonnistui. Yrita uudelleen.';
      });
      if (mounted) {
        _showMessage('Rekisterointi epaonnistui. Yrita uudelleen.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _authErrorText(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Sahkopostiosoite ei ole kelvollinen.';
      case 'missing-email':
        return 'Sahkoposti puuttuu.';
      case 'missing-password':
        return 'Salasana puuttuu.';
      case 'user-not-found':
        return 'Kayttajaa ei loydy.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Vaarat kirjautumistiedot.';
      case 'email-already-in-use':
        return 'Sahkoposti on jo kaytossa.';
      case 'weak-password':
        return 'Salasana on liian heikko (vähintään 6 merkkiä).';
      case 'operation-not-allowed':
        return 'Email/salasana-kirjautuminen ei ole paalla Firebase Authissa.';
      case 'too-many-requests':
        return 'Liian monta yritysta. Yrita hetken kuluttua uudelleen.';
      default:
        return e.message ?? 'Tapahtui virhe.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Kirjautuminen'),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Salasana'),
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    child: const Text('Kirjaudu sisaan'),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _register,
                    child: const Text('Rekisteroidy'),
                  ),
                ),
                if (_isLoading) ...[
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _noteController = TextEditingController();
  String? _saveError;
  bool _isSaving = false;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  CollectionReference<Map<String, dynamic>> _notesRef(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notes');
  }

  Future<void> _addNote(String uid) async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      await _notesRef(uid).add({
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _noteController.clear();
    } on FirebaseException catch (e) {
      setState(() {
        _saveError = e.code == 'permission-denied'
            ? 'Ei oikeuksia tallentaa muistiinpanoa.'
            : 'Muistiinpanon tallennus epaonnistui. Yrita uudelleen.';
      });
    } catch (_) {
      setState(() {
        _saveError =
            'Muistiinpanon tallennus epaonnistui. Yrita uudelleen.';
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _editNote(
    String uid,
    String noteId,
    String currentText,
  ) async {
    final controller = TextEditingController(text: currentText);
    final newText = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Muokkaa muistiinpanoa'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Muistiinpanon teksti',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Peruuta'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Tallenna'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newText == null) return;
    if (newText.isEmpty) {
      setState(() {
        _saveError = 'Tyhjaa muistiinpanoa ei voi tallentaa.';
      });
      _showMessage('Tyhjaa muistiinpanoa ei voi tallentaa.');
      return;
    }

    try {
      await _notesRef(uid).doc(noteId).update({
        'text': newText,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        setState(() {
          _saveError = null;
        });
      }
    } on FirebaseException catch (_) {
      setState(() {
        _saveError = 'Muistiinpanon muokkaus epaonnistui.';
      });
      _showMessage('Muistiinpanon muokkaus epaonnistui.');
    } catch (_) {
      setState(() {
        _saveError = 'Muistiinpanon muokkaus epaonnistui.';
      });
      _showMessage('Muistiinpanon muokkaus epaonnistui.');
    }
  }

  Future<void> _deleteNote(String uid, String noteId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Poista muistiinpano'),
          content: const Text('Haluatko varmasti poistaa muistiinpanon?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Peruuta'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Poista'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await _notesRef(uid).doc(noteId).delete();
      if (mounted) {
        setState(() {
          _saveError = null;
        });
      }
    } on FirebaseException catch (_) {
      setState(() {
        _saveError = 'Muistiinpanon poisto epaonnistui.';
      });
      _showMessage('Muistiinpanon poisto epaonnistui.');
    } catch (_) {
      setState(() {
        _saveError = 'Muistiinpanon poisto epaonnistui.';
      });
      _showMessage('Muistiinpanon poisto epaonnistui.');
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final uid = user.uid;
    final notesStream = _notesRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Uusi muistiinpano',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isSaving ? null : () => _addNote(uid),
                  child: const Text('Lisää muistiinpano'),
                ),
                if (_saveError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _saveError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Omat muistiinpanot'),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: notesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Muistiinpanojen lataus epaonnistui: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                    child: Text('Ei viela muistiinpanoja.'),
                  );
                }
                return ListView.separated(
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final text = data['text'] as String? ?? '';
                    final createdAt = data['createdAt'];
                    String subtitle = '';
                    if (createdAt is Timestamp) {
                      subtitle = createdAt.toDate().toLocal().toString();
                    }
                    return ListTile(
                      title: Text(text),
                      subtitle: subtitle.isEmpty ? null : Text(subtitle),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Muokkaa',
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editNote(uid, docs[index].id, text),
                          ),
                          IconButton(
                            tooltip: 'Poista',
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteNote(uid, docs[index].id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _signOut,
              child: const Text('Kirjaudu ulos'),
            ),
          ),
        ],
      ),
    );
  }
}
