import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Destination {
  final String id;
  final String title;
  final String imagePath;
  final String tag;
  final String description;

  Destination({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.tag,
    required this.description,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PakistanTravelQuest',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepPurpleAccent,
        ),
      ),
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: 'Alizay');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();

  double _formOpacity = 0.0;
  double _buttonWidth = 200.0;
  Color _buttonColor = Colors.purple;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _formOpacity = 1.0;
      });
    });
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', _nameController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('country', _countryController.text);
      await prefs.setString('budget', _budgetController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  void _onButtonTapDown(TapDownDetails details) {
    setState(() {
      _buttonWidth = 180.0;
      _buttonColor = Colors.deepPurple;
    });
  }

  void _onButtonTapUp(TapUpDetails details) {
    setState(() {
      _buttonWidth = 200.0;
      _buttonColor = Colors.purple;
    });
    _saveData();
  }

  InputDecoration _buildInputDec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.purple),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.purple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'app-logo',
                child: Icon(Icons.flight_takeoff, size: 80, color: Colors.purple),
              ),
              SizedBox(height: 20),
              Text(
                  "PakistanTravelQuest",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.purple[800])
              ),
              SizedBox(height: 30),

              AnimatedOpacity(
                opacity: _formOpacity,
                duration: Duration(seconds: 1),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDec("Full Name", Icons.person),
                        validator: (value) {
                          if (value == null || value.length < 3) return "Name must be at least 3 chars";
                          return null;
                        },
                      ),
                      SizedBox(height: 15),

                      TextFormField(
                        controller: _emailController,
                        decoration: _buildInputDec("Email", Icons.email),
                        validator: (value) {
                          if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),

                      TextFormField(
                        controller: _countryController,
                        decoration: _buildInputDec("Country", Icons.flag),
                        validator: (value) => value!.isEmpty ? "Country is required" : null,
                      ),
                      SizedBox(height: 15),

                      TextFormField(
                        controller: _budgetController,
                        keyboardType: TextInputType.number,
                        decoration: _buildInputDec("Travel Budget (PKR)", Icons.attach_money),
                        validator: (value) {
                          if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                            return "Enter a positive number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),

                      GestureDetector(
                        onTapDown: _onButtonTapDown,
                        onTapUp: _onButtonTapUp,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: _buttonWidth,
                          height: 55,
                          decoration: BoxDecoration(
                            color: _buttonColor,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                  color: _buttonColor.withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: Offset(0, 6)
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                              "Register Now",
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _userName = "Alizay";

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  double _profileSize = 80.0;
  Color _profileColor = Colors.purple;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('fullName') ?? "Alizay";
    });
  }

  void _toggleProfile() {
    setState(() {
      _profileSize = _profileSize == 80.0 ? 120.0 : 80.0;
      _profileColor = _profileColor == Colors.purple ? Colors.deepPurple : Colors.purple;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, $_userName!"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Hero(
            tag: 'app-logo',
            child: Icon(Icons.flight_takeoff, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return Row(
              children: [
                Expanded(child: _buildProfileSection()),
                Expanded(child: _buildMainContent()),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileSection(),
                  _buildMainContent(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleProfile,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: _profileSize,
              height: _profileSize,
              decoration: BoxDecoration(
                color: _profileColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: Icon(Icons.person, color: Colors.white, size: _profileSize / 2),
            ),
          ),
          SizedBox(height: 10),
          Text("Tap avatar to resize!", style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    shape: BoxShape.circle
                ),
                child: Icon(Icons.map, color: Colors.deepPurple),
              ),
              title: Text("Adventures Explored", style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text("8", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple)),
            ),
          ),
          SizedBox(height: 40),

          SlideTransition(
            position: _offsetAnimation,
            child: Icon(Icons.airplanemode_active, size: 50, color: Colors.purple),
          ),

          SizedBox(height: 50),

          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 5,
              ),
              icon: Icon(Icons.explore),
              label: Text("Start Exploring Pakistan", style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExploreScreen()),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  final List<Destination> destinations = [
    Destination(id: '1', title: 'Islamabad', tag: 'Capital', imagePath: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/11/71/95/61/faisal-mosque.jpg?w=1400&h=-1&s=1', description: 'The beautiful capital, home to the iconic Faisal Mosque.'),
    Destination(id: '2', title: 'Karachi', tag: 'Coastal', imagePath: 'https://media.istockphoto.com/id/185003293/photo/the-icon-of-karachi.jpg?s=2048x2048&w=is&k=20&c=p5JMhUW5kHLXBhI7suQZCwb6TdM6uzckNLk5qDFyFok=', description: 'The City of Lights and Pakistan\'s bustling economic hub.'),
    Destination(id: '3', title: 'Lahore', tag: 'Historical', imagePath: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/c6/75/fe/badshahi-masjid-lahore.jpg?w=1100&h=-1&s=1', description: 'The cultural heart of Pakistan, home to the grand Badshahi Mosque.'),
    Destination(id: '4', title: 'Peshawar', tag: 'Frontier', imagePath: 'https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcRlRgN004gbB3K8sxJdvxGTuM72rDspSmvb3vjTMlWQRjo63oLgIR-lZOWu88mIGJA8hQo4JbeEydq_H0t5-uOojpVp&s=19', description: 'Ancient city and center of Pashtun culture.'),
    Destination(id: '5', title: 'Multan', tag: 'Sufi', imagePath: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/11/88/34/46/tomb-hamid-shah-gillani.jpg?w=2400&h=-1&s=1', description: 'The City of Saints, known for its tombs and shrines.'),
    Destination(id: '6', title: 'Gilgit', tag: 'Mountains', imagePath: 'https://media-cdn.tripadvisor.com/media/attractions-splice-spp-674x446/07/35/a1/21.jpg', description: 'Gateway to the Karakoram Range and stunning northern views.'),
    Destination(id: '7', title: 'Quetta', tag: 'Balochistan', imagePath: 'https://upload.wikimedia.org/wikipedia/commons/5/57/Quetta_cantt.jpg', description: 'Surrounded by hills, a blend of different cultures.'),
    Destination(id: '8', title: 'Faisalabad', tag: 'Industrial', imagePath: 'https://upload.wikimedia.org/wikipedia/commons/f/f1/Clock_Tower_Faisalabad_by_Usman_Nadeem.jpg', description: 'The Manchester of Pakistan, a major textile city.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explore Pakistani Cities")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 2;
          double width = constraints.maxWidth;

          if (width < 400) {
            crossAxisCount = 2;
          } else if (width >= 400 && width < 700) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 4;
          }

          return GridView.builder(
            padding: EdgeInsets.all(15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.8,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final dest = destinations[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(destination: dest),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: dest.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.network(
                              dest.imagePath,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: CircularProgressIndicator(color: Colors.purple));
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dest.title,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 6),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                dest.tag,
                                style: TextStyle(color: Colors.purple, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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

class DetailScreen extends StatefulWidget {
  final Destination destination;

  const DetailScreen({Key? key, required this.destination}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with TickerProviderStateMixin {

  late AnimationController _entryController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _heartController;
  late Animation<double> _scaleAnimation;

  bool _isWishlisted = false;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: Curves.easeIn));

    _entryController.forward();

    _heartController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _heartController, curve: Curves.elasticOut));

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _heartController.reverse();
      }
    });
  }

  void _addToWishlist() {
    setState(() {
      _isWishlisted = !_isWishlisted;
    });

    _heartController.forward();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.destination.title} added to Wishlist!"),
        backgroundColor: Colors.purple[800],
        duration: Duration(seconds: 1),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.white,
            shadows: [Shadow(color: Colors.black54, blurRadius: 10)]
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: widget.destination.id,
              child: Image.network(
                widget.destination.imagePath,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),

            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.destination.title,
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.purple[900]),
                          ),

                          ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
                              ),
                              child: IconButton(
                                icon: Icon(
                                  _isWishlisted ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.redAccent,
                                  size: 28,
                                ),
                                onPressed: _addToWishlist,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.destination.tag,
                          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "About Destination",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.purple[800]),
                      ),
                      SizedBox(height: 12),
                      Text(
                        widget.destination.description,
                        style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Experience the rich culture and stunning landscapes of ${widget.destination.title}. "
                            "Book your adventure now and explore the beauty of Pakistan.",
                        style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 18),
            backgroundColor: Colors.purple,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
          ),
          onPressed: _addToWishlist,
          child: Text("Add to Wishlist", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}