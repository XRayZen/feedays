// Register a valid site
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';

Future<List<WebSite>> genValidSite() async{
  final paths = [
    'http://jin115.com/',
    'http://blog.esuteru.com/',
    'https://gigazine.net/',
    'https://iphone-mania.jp/'
  ];
  final sites = List<WebSite>.empty(growable: true);
  for (final path in paths) {
    final repo = WebRepoImpl();
    final site =await repo.fetchSiteOgpMeta(path);
    sites.add(WebSite.mock(site.siteUrl, site.name, 'Anime'));
  }
  return sites;
}
