// Register a valid site
import 'package:feedays/domain/entities/web_sites.dart';

void genValidSite() {
  final paths = [
    'http://jin115.com/',
    'http://blog.esuteru.com/',
    'https://gigazine.net/',
    'https://iphone-mania.jp/'
  ];
  final sites = List.empty(growable: true);
  for (final path in paths) {
    sites.add(WebSite.mock(path, '', 'Anime'));
  }
  
}
