import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<CarouselItems> items;
  final double width, height;
  final BorderRadiusGeometry borderRadius;
  final bool autoplay;
  Carousel(
      {@required this.items,
      @required this.width,
      this.height,
      this.borderRadius,
      this.autoplay})
      : assert(items != null && width != null);
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _index = 0;
  bool error = false;
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
                child: ClipRRect(
                  child: Image.network(
                    item.image,
                    fit: BoxFit.fill,
                    width: widget.width,
                    height: widget.height,
                    errorBuilder: (BuildContext context, Object object,
                        StackTrace trace) {
                      return Icon(
                        Icons.error,
                        color: Colors.white,
                        size: 30,
                      );
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent event) {
                      return event == null
                          ? child
                          : Container(
                              height: widget.height,
                              width: widget.width,
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.grey),
                                ),
                              ),
                            );
                    },
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: item.onTap,
              );
            }).toList(),
            options: CarouselOptions(
                initialPage: 1,
                height: widget.height ?? 200,
                autoPlay: widget.autoplay ?? true,
                viewportFraction: 1,
                aspectRatio: 16 / 9,
                // autoPlayCurve: Curves.easeInToLinear,
                // enlargeCenterPage: true,
                autoPlayAnimationDuration: Duration(milliseconds: 900),
                onPageChanged: (index, reason) {
                  setState(() {
                    _index = index;
                  });
                }),
          ),
          Container(
            height: 20,
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.items.map((i) {
                int index = widget.items.indexOf(i);
                return AnimatedContainer(
                  duration: Duration(milliseconds: 800),
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  height: 10,
                  width: _index == index ? 20 : 10,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    color: _index == index ? Colors.grey : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class CarouselItems {
  final String title, category, categoryId, image;
  final GestureTapCallback onTap;
  CarouselItems(
      {@required this.image,
      this.title,
      this.category,
      this.onTap,
      this.categoryId});
}
