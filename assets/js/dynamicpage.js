document.write = function(content) {
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
        $window = $(window),
		$body = $('body'),
        $mainContent = $("#banner-wrapper"),
        $pageWrap    = $("#page-wrapper"),
        baseHeight   = 0,
        $el;

    $pageWrap.height($pageWrap.height());
    baseHeight = $pageWrap.height() - $mainContent.height();

    	// Breakpoints.
		breakpoints({
			xlarge:  [ '1281px',  '1680px' ],
			large:   [ '981px',   '1280px' ],
			medium:  [ '737px',   '980px'  ],
			small:   [ null,      '736px'  ]
		});

	// Play initial animations on page load.
		$window.on('load', function() {
			window.setTimeout(function() {
				$body.removeClass('is-preload');
			}, 100);
		});

    // // Dropdowns.
	// $('#nav > ul').dropotron({
	// 	mode: 'fade',
	// 	noOpenerFade: true,
	// 	speed: 300
	// });



	// Nav.

	// Toggle.
	$(
		'<div id="navToggle">' +
			'<a href="#navPanel" class="toggle"></a>' +
			'</div>'
	)
		.appendTo($body);
	// Panel.
	$(
		'<div id="navPanel">' +
			'<nav>' +
			$('#nav').navList() +
			'</nav>' +
			'</div>'
	)
		.appendTo($body)
		.panel({
			delay: 500,
			hideOnClick: true,
			hideOnSwipe: true,
			resetScroll: true,
			resetForms: true,
			side: 'left',
			target: $body,
			visibleClass: 'navPanel-visible'
		});

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
                $.ajax({url: newHash + ".html",
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
