import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniState createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final TextEditingController _epostaKontrolcusu = TextEditingController();
  final TextEditingController _sifreKontrolcusu = TextEditingController();
  final FirebaseAuth _yetkilendirme = FirebaseAuth.instance;

  String _hataMesaji = '';

  Future<void> _googleIleGirisYap() async {
    setState(() {
      _hataMesaji = '';
    });
    try {
      final GoogleSignInAccount? googleKullanicisi = await GoogleSignIn().signIn();
      if (googleKullanicisi == null) return;

      final GoogleSignInAuthentication googleKimlikDogrulama =
          await googleKullanicisi.authentication;

      final AuthCredential kimlikBilgisi = GoogleAuthProvider.credential(
        accessToken: googleKimlikDogrulama.accessToken,
        idToken: googleKimlikDogrulama.idToken,
      );

      await _yetkilendirme.signInWithCredential(kimlikBilgisi);

      Navigator.pushReplacementNamed(context, '/anasayfa');
    } on FirebaseAuthException catch (hata) {
      setState(() {
        _hataMesaji = _firebaseHataMesajiAl(hata.code);
      });
    } catch (hata) {
      setState(() {
        _hataMesaji = 'Google Girişi Sırasında Hata: ${hata.toString()}';
      });
    }
  }
  
  Future<void> _epostaVeSifreIleGirisYap() async {
    setState(() {
      _hataMesaji = '';
    });
    try {
      await _yetkilendirme.signInWithEmailAndPassword(
        email: _epostaKontrolcusu.text.trim(),
        password: _sifreKontrolcusu.text,
      );
      Navigator.pushReplacementNamed(context, '/anasayfa');
    } on FirebaseAuthException catch (hata) {
      setState(() {
        _hataMesaji = _firebaseHataMesajiAl(hata.code);
      });
    } catch (hata) {
      setState(() {
        _hataMesaji = 'Giriş sırasında bir hata oluştu: ${hata.toString()}';
      });
    }
  }

  String _firebaseHataMesajiAl(String hataKodu) {
    switch (hataKodu) {
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmış.';
      case 'user-not-found':
        return 'Bu e-posta adresine kayıtlı kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Yanlış şifre girdiniz.';
      case 'network-request-failed':
        return 'İnternet bağlantısı hatası, lütfen kontrol edin.';
      default:
        return 'Bilinmeyen bir hata oluştu: $hataKodu';
    }
  }

  @override
  void dispose() {
    _epostaKontrolcusu.dispose();
    _sifreKontrolcusu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context); 
        },
      ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 250,
                height: 50,
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  onPressed: _googleIleGirisYap,
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Image.asset(
                      'resimler/gg.png',
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                    ),
                  ),
                  label: Text('Google ile Giriş Yap'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _epostaKontrolcusu,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _sifreKontrolcusu,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                  onPressed: _epostaVeSifreIleGirisYap,
                  style: ElevatedButton.styleFrom(
                   shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(4)),
                   backgroundColor: Colors.white,
                  side: const BorderSide(color: Color(0xff371B34), width: 1),
                 ),
                 child: Text('Giriş Yap'),
                     ),

              SizedBox(height: 16),
              Text(
                _hataMesaji,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
