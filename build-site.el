(require 'htmlize)
(require 'org-publish-rss)
(require 'ox-publish)

(setq org-html-html5-fancy t
      org-html-doctype "html5"
      org-html-validation-link nil
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" /> <link rel=\"alternate\" type=\"application/rss+xml\" title=\"Notes from Andreas Zweili\" href=\"https://2li.ch/rss.xml\" />"
      org-publish-timestamp-directory "./.cache/"
      )

(setq org-publish-project-alist
      `(("posts"
         :recursive t
         :author "Andreas Zweili"
         :base-directory "./posts"
         :publishing-function org-html-publish-to-html
         :publishing-directory "./public"
         :with-author nil
         :with-creator t
         :with-toc t
         :section-numbers nil
         :time-stamp-file nil
         :html-link-home "https://www.2li.ch"
         :html-link-up "/"
         :html-postamble "<footer>
         <p xmlns:cc=\"http://creativecommons.org/ns#\"
         xmlns:dct=\"http://purl.org/dc/terms/\"><a property=\"dct:title\"
         rel=\"cc:attributionURL nofollow noopener noreferrer\"
         href=\"https://www.2li.ch\" target=\"_blank\" class=\"external-link
         no-image\">Notes</a> by <a rel=\"cc:attributionURL dct:creator nofollow
         noopener noreferrer\" property=\"cc:attributionName\"
         href=\"https://social.linux.pizza/@nebucatnetzer\" target=\"_blank\"
         class=\"external-link no-image\">Andreas Zweili</a> is licensed under <a
         href=\"http://creativecommons.org/licenses/by-sa/4.0/?ref=chooser-v1\"
         target=\"_blank\" rel=\"license noopener noreferrer nofollow\"
         style=\"display:inline-block;\" class=\"external-link images\">CC BY-SA
         4.0<img
         style=\"height:22px!important;margin-left:3px;vertical-align:text-bottom;\"
         src=\"https://mirrors.creativecommons.org/presskit/icons/cc.svg?ref=chooser-v1\"
         /><img
         style=\"height:22px!important;margin-left:3px;vertical-align:text-bottom;\"
         src=\"https://mirrors.creativecommons.org/presskit/icons/by.svg?ref=chooser-v1\"
         /><img
         style=\"height:22px!important;margin-left:3px;vertical-align:text-bottom;\"
         src=\"https://mirrors.creativecommons.org/presskit/icons/sa.svg?ref=chooser-v1\"
         /></a></p>

         <div class=\"generated\">
         Created with %c on <a href=\"https://www.gnu.org\">GNU</a>/<a href=\"https://www.kernel.org/\">Linux</a>
         </div>
         </footer>"

         :auto-sitemap t
         :sitemap-title "Sitemap for Andreas Zweili's notes"
         :sitemap-filename "sitemap.org"
         :sitemap-style list
         :sitemap-sort-folders ignore

         :auto-rss t
         :rss-title "Andreas Zweili's Blog"
         :rss-description "Blog posts on Free Software, technology, etc."
         :rss-with-content all
         :completion-function org-publish-rss
         )
        ("static"
         :base-directory "./posts/"
         :base-extension "css\\|txt\\|jpg\\|gif\\|png"
         :recursive t
         :include ("rss.xml")
         :publishing-directory  "./public/"
         :publishing-function org-publish-attachment)
        ("blog" :components ("posts" "static"))
        )
      )

(org-publish "blog" t)
(message "Build complete!")
