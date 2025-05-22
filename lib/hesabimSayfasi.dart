import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class HesabimSayfasi extends StatelessWidget {
  const HesabimSayfasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: user == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hesabım",
                      style: GoogleFonts.alegreya(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : AssetImage('resimler/default_avatar.png') as ImageProvider,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName ?? 'İsimsiz Kullanıcı',
                              style: GoogleFonts.alegreya(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              user.email ?? '',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("Ayarlar"),
                      onTap: () {
                        
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.feedback),
                      title: Text("Geri Bildirim"),
                      onTap: () {
                        
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("Çıkış Yap"),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacementNamed('/login'); 
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
