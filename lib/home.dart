import 'package:flutter/material.dart';

  class home extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          actionsPadding: EdgeInsets.only(
              left: 26.0, right: 26.0, bottom: 10.0),
          title: Text(
            'Hello, Chef Bob',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage('assets/miae.jpg'),
            ),
          ],
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(26.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                SizedBox(
                  width: double.infinity,
                  height: 52.0,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for events, figures or places',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        color: Colors.grey[400],
                      ),
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding:
                      const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // "Today in 1945"
                Padding(
                  padding: EdgeInsets.only(top: 22.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Today in  ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '1945',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.0),

                // first card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.asset('assets/WWII.png'),
                          ),
                          SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'End of WWII',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                '1945',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'In Europe, the war ended on May 7, 1945, when Nazi Germany officially surrendered to the Allied forces. This came after months of...',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(height: 14.0),
                          SizedBox(
                            width: double.infinity,
                            height: 42.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                'Discover',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                ),

                SizedBox(height: 30.0), // space bin cards
                Text(
                  'Discover',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 12.0),
                //second card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset('assets/WWII.png'),
                        ),
                        SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'End of WWII',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '1945',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'In Europe, the war ended on May 7, 1945, when Nazi Germany officially surrendered to the Allied forces. This came after months of...',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: 14.0),
                        SizedBox(
                          width: double.infinity,
                          height: 42.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Discover',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ),
      );
    }
  }