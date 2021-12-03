// Generated code for this Image Widget...
ClipRRect(
  borderRadius: BorderRadius.circular(18),
  child: Image.asset(
    'assets/images/r-architecture-TRCJ-87Yoh0-unsplash.jpg',
    width: 100,
    height: 100,
    fit: BoxFit.cover,
  ),
)



// Generated code for this Column Widget...
SingleChildScrollView(
  child: Column(
    mainAxisSize: MainAxisSize.max,
    children: [
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              buttonSize: 46,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 4, 0),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    buttonSize: 46,
                    icon: Icon(
                      Icons.more_vert_sharp,
                      color: Color(0xFFDBE2E7),
                      size: 24,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ),
                FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  buttonSize: 46,
                  icon: Icon(
                    Icons.notifications_none,
                    color: Color(0xFFDBE2E7),
                    size: 24,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                )
              ],
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                child: Text(
                  'Spectacular Views of Queenstown',
                  style: FlutterFlowTheme.title1.override(
                    fontFamily: 'Lexend Deca',
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.star_rate_rounded,
              color: Color(0xFFFFA130),
              size: 24,
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
              child: Text(
                '4.7',
                style: FlutterFlowTheme.bodyText2.override(
                  fontFamily: 'Lexend Deca',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
              child: Icon(
                Icons.house_rounded,
                color: Color(0xFF95A1AC),
                size: 24,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
              child: Text(
                'Superhost',
                style: FlutterFlowTheme.subtitle2.override(
                  fontFamily: 'Lexend Deca',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Color(0xFF95A1AC),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    buttonSize: 46,
                    icon: Icon(
                      Icons.ios_share,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Color(0xFF95A1AC),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                  child: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30,
                    buttonSize: 46,
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Color(0xFF95A1AC),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30,
                  buttonSize: 46,
                  icon: Icon(
                    Icons.threed_rotation,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 360,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Container(
            width: double.infinity,
            height: 500,
            child: Stack(
              children: [
                PageView(
                  controller: pageViewController ??=
                      PageController(initialPage: 0),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/images/r-architecture-TRCJ-87Yoh0-unsplash.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Image.network(
                      'https://picsum.photos/seed/783/600',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional(0, 1),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: SmoothPageIndicator(
                      controller: pageViewController ??=
                          PageController(initialPage: 0),
                      count: 2,
                      axisDirection: Axis.horizontal,
                      onDotClicked: (i) {
                        pageViewController.animateToPage(
                          i,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      effect: ExpandingDotsEffect(
                        expansionFactor: 1.5,
                        spacing: 8,
                        radius: 30,
                        dotWidth: 13,
                        dotHeight: 13,
                        dotColor: Color(0x9D9E9E9E),
                        activeDotColor: Colors.white,
                        paintStyle: PaintingStyle.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Color(0xFF14181B),
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x55000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '\$156',
                          style: FlutterFlowTheme.subtitle1.override(
                            fontFamily: 'Lexend Deca',
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                          child: Text(
                            '+ taxes',
                            style: FlutterFlowTheme.bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF8B97A2),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text(
                        'per night',
                        style: FlutterFlowTheme.bodyText2.override(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF8B97A2),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
                FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'Book Now',
                  options: FFButtonOptions(
                    width: 130,
                    height: 50,
                    color: Color(0xFF4B39EF),
                    textStyle: FlutterFlowTheme.subtitle2.override(
                      fontFamily: 'Lexend Deca',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: 30,
                  ),
                  loading: _loadingButton,
                )
              ],
            ),
          ),
        ),
      )
    ],
  ),
)
