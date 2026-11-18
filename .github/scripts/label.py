# Marks every page in /uat/ and /beta/ with a colored banner and hides it from search engines.
import sys, pathlib, re
root = pathlib.Path(sys.argv[1])
LABEL = {"uat": ("#9A6A12", "UAT: waiting for approval. Not the live site."),
         "beta": ("#A3271F", "BETA: testing version. Not approved.")}
for env, (color, text) in LABEL.items():
    for f in (root / env).rglob("*.html"):
        s = f.read_text(encoding="utf-8", errors="ignore")
        tag = ('<meta name="robots" content="noindex,nofollow">'
               '<script>addEventListener("DOMContentLoaded",function(){if(top!==self)return;'
               'var b=document.createElement("div");b.textContent=' + repr(text) + ';'
               'b.style.cssText="position:fixed;left:0;right:0;bottom:0;z-index:2147483647;background:' + color + ';color:#fff;'
               'font:700 14px/1.2 Helvetica,Arial,sans-serif;text-align:center;padding:8px 16px calc(8px + env(safe-area-inset-bottom,0px))";'
               'document.body.appendChild(b)})</script>')
        m = re.search(r"<head[^>]*>", s, re.I)
        s = s[:m.end()] + tag + s[m.end():] if m else tag + s
        f.write_text(s, encoding="utf-8")
print("labelled uat and beta")
