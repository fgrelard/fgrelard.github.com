document.write = function(content) {
    console.log(content);
    if (document.currentScript) {
        // var src = document.currentScript.src;
        var src = document.currentScript.src
            .replace(/\#.*$/, '')
            .replace(/\?.*$/, '')
            .replace(/^.*\/\//, '');
        setTimeout(function() {
            var script = $('script').filter(function() {
                var scriptSrc = $(this).attr('src');
                return scriptSrc && scriptSrc.indexOf(src) !== -1;
            });
            $('<div></div>')
                .addClass('doc-write')
                .html(content)
                .insertAfter($("#bib"));
        }, 0);
    } else {
        HTMLDocument.prototype.write.apply(document, arguments);
    }
};


$("#page-wrapper").hide();

$("#header-wrapper").load("header.html", function() {
    var newHash      = "",
        $mainContent = $("#banner-wrapper"),
        $pageWrap    = $("#page-wrapper"),
        baseHeight   = 0,
        $el;

    $pageWrap.height($pageWrap.height());
    baseHeight = $pageWrap.height() - $mainContent.height();

    $("nav").delegate("a", "click", function(e) {
        e.preventDefault();
        window.location.hash = $(this).attr("href");
        return false;
    });

    $(window).bind('hashchange', function(){
        $("#copyright").hide();
        newHash = window.location.hash.substring(1) || "about";
        $mainContent
            .fadeOut(300, function() {
                $mainContent.hide();
                $.ajax({url: newHash + ".html #banner",
                        success: function(data, status , jqXHR) {
                            $mainContent.html($(data).find("#banner").addBack("#banner")).fadeIn(300);
                            $("nav a").parent().removeClass("current");
                            $("nav a[href='"+newHash+"']").parent().addClass("current");
                            $("#copyright").show();
                            $("#page-wrapper").show();
                            $('.carousel').carousel({
	                            interval: 4000
	                        });
                        }

                       });
            })
;

    });

    $(window).trigger('hashchange');

});
