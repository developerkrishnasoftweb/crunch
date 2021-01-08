import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../Static/Constant.dart' as cnst;

class Carousel extends StatefulWidget {
  final List<CarouselItems> items;
  final double width, height;
  final BorderRadiusGeometry borderRadius;
  Carousel({@required this.items, @required this.width, this.height, this.borderRadius}) : assert(items != null && width != null);
  @override
  _CarouselState createState() => _CarouselState();
}
class _CarouselState extends State<Carousel> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height != null ? widget.height + 20 : 220,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? null,
      ),
      child: Column(
        children: [
          CarouselSlider(
            items: widget.items.map((item) {
              return GestureDetector(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: item.image,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: widget.borderRadius ?? null,
                  ),
                  child: Container(
                    height: 50,
                    width: widget.width,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: widget.borderRadius,
                    ),
                  ),
                ),
                onTap: item.onTap,
              );
            }).toList(),
            options: CarouselOptions(
                initialPage: 1,
                height: widget.height ?? 200,
                autoPlay: true,
                viewportFraction: 1,
                aspectRatio: 16 / 9,
                // autoPlayCurve: Curves.easeInToLinear,
                enlargeCenterPage: true,
                autoPlayAnimationDuration: Duration(milliseconds: 900),
                onPageChanged: (index, reason) {
                  setState(() {
                    _index = index;
                  });
                }),
          ),
        ],
      ),
    );
  }
}

class CarouselItems {
  final String title, category, categoryId;
  final ImageProvider image;
  final GestureTapCallback onTap;

  CarouselItems({@required this.image, this.title, this.category, this.onTap, this.categoryId});
}