// Register a valid site
import 'package:feedays/domain/entities/web_sites.dart';
import 'package:feedays/infra/impl_repo/web_repo_impl.dart';

Future<List<WebSite>> genValidSite() async {
  final paths = [
    'http://jin115.com/',
    'http://blog.esuteru.com/',
    'https://gigazine.net/',
    'https://iphone-mania.jp/'
  ];
  final sites = List<WebSite>.empty(growable: true);
  for (final path in paths) {
    final repo = WebRepoImpl();
    final site = await repo.fetchSiteOgpMeta(path);
    sites.add(WebSite.mock(site.siteUrl, site.name, 'Mock'));
  }
  return sites;
}

//PLAN:ポートフォリオ用で作っているから無難なサイトをまとめる

List<WebSite> genExploreList() {
  final gameSites = {
    WebSite.mock('https://jp.ign.com/', 'IGN', '#Game'),
    WebSite.mock('https://automaton-media.com/', 'AUTOMATION', '#Game'),
    WebSite.mock('https://www.4gamer.net/', '4Gamer', '#Game'),
  };
  const invest = '#Invest';
  final investSites = {
    WebSite.mock('https://randomwalker.blog.fc2.com/', '商店街ランダムウォーカー', invest),
    WebSite.mock('https://takezo50.com/', 'たけぞう', invest),
    WebSite.mock('https://kabumatome.doorblog.jp/', '二階建て', invest),
  };
  const cate = '#Programming';
  final programmingSites = {
    WebSite.mock('https://techlife.cookpad.com/', 'クックパッド開発', cate),
    WebSite.mock('https://codezine.jp/', 'CodeZine', cate),
    WebSite.mock('https://techblog.yahoo.co.jp/', 'Yahoo JP Tech', cate),
    WebSite.mock('https://developer.hatenastaff.com/', 'Hatena Dev Blog', cate),
  };
  const category3 = '#News';
  final sites3 = {
    WebSite.mock('https://news.yahoo.co.jp/rss/topics/top-picks.xml', 'Yahoo主要',
        category3,),
    WebSite.mock('https://news.yahoo.co.jp/rss/topics/business.xml',
        'Yahoo!ニュース・トピックス - 経済', category3,),
    WebSite.mock('https://news.yahoo.co.jp/rss/categories/domestic.xml',
        '国内 - Yahoo!ニュース', category3,),
    WebSite.mock('https://news.yahoo.co.jp/rss/categories/it.xml',
        'IT - Yahoo!ニュース', category3,),
    WebSite.mock('https://news.yahoo.co.jp/rss/categories/business.xml',
        '経済 - Yahoo!ニュース', category3,),
    WebSite.mock('https://news.yahoo.co.jp/rss/categories/world.xml',
        '国際 - Yahoo!ニュース', category3,),
  };
  final sites = List<WebSite>.empty(growable: true)
    ..addAll(gameSites)
    ..addAll(investSites)
    ..addAll(programmingSites)
    ..addAll(sites3);
  return sites;
}

//FIXME:実用的なサイト部分はポートフォリオ提出時に削除
//PLAN:アプリを実用的にするにはクラウドでサイトを登録しておく
void genPracticalSites() {
  const category = '2ch';
  final Sites1 = {
    WebSite.mock('', '', category),
    WebSite.mock('', '', category),
    WebSite.mock('', '', category),
    WebSite.mock('', '', category),
  };
  const category2 = 'Fav';
  final Sites2 = {
    WebSite.mock('', '', category2),
    WebSite.mock('', '', category2),
    WebSite.mock('', '', category2),
    WebSite.mock('', '', category2),
  };
  const category3 = 'News';
  final Sites3 = {
    WebSite.mock('', '', category3),
    WebSite.mock('', '', category3),
    WebSite.mock('', '', category3),
    WebSite.mock('', '', category3),
  };
  const category4 = 'Manga';
  final Sites4 = {
    WebSite.mock('', '', category4),
    WebSite.mock('', '', category4),
    WebSite.mock('', '', category4),
    WebSite.mock('', '', category4),
  };
}
