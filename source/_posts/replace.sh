echo $1
gsed -i ' /\$\$/ { s/\$\$/{% math %}/;:a; N; /\$\$/! ba; s/\$\$/{% endmath %}/};s/\(\$\)\([^$]*\)\(\$\)/{% math %}\2{% endmath %}/g ' $1

