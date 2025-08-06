(require 'htmlize)
(require 'org-publish-rss)
(require 'ox-publish)

(setopt org-html-html5-fancy t
        org-html-doctype "html5"
        org-html-validation-link nil
        org-html-head-include-scripts nil
        org-html-head-include-default-style nil
        org-html-head "<link rel=\"stylesheet\" href=\"/static/styles.css\" />
                     <link rel=\"alternate\" type=\"application/rss+xml\" title=\"Notes from Andreas Zweili\" href=\"https://2li.ch/rss.xml\" />"
        org-publish-timestamp-directory "./.cache/"
        org-export-with-section-numbers nil
        )

(setopt org-publish-project-alist
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
         <div>
         <a href=\"https://www.2li.ch\">Notes</a> © 2025 by <a
            href=\"https://social.linux.pizza/@nebucatnetzer\">Andreas Zweili</a> is licensed under <a
            href=\"https://creativecommons.org/licenses/by-sa/4.0/\">CC BY-SA 4.0
         </a>
         </div>

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
