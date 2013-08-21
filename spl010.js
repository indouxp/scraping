var links = [];
var casper = require('casper').create();

function getLinks() {
    var links = document.querySelectorAll('h3.r a');
    return Array.prototype.map.call(links, function(e) {
        return e.getAttribute('href')
    });
}

casper.start('http://google.co.jp/', function() {
    // google から 'casperjs' を検索
    this.fill('form[action="/search"]', { q: 'casperjs' }, true);
});

casper.then(function() {
    // 'casperjs' の検索結果をまとめる
    links = this.evaluate(getLinks);
    // 今度は 'phantomjs' を検索するためにフォームを埋める
    this.fill('form[action="/search"]', { q: 'phantomjs' }, true);
});

casper.then(function() {
    // 'phantomjs' の検索結果をまとめる
    links = links.concat(this.evaluate(getLinks));
});

casper.run(function() {
    // 結果表示をおめかし☆（ゝω・）vｷｬﾋﾟ
    this.echo(links.length + ' links found:');
    this.echo(' - ' + links.join('\n - ')).exit();
});
