# Mail XZ — imagem Mautic customizada (golden image, versão fixa 4.4)
# Base oficial pinada; nossas personalizações vão aqui e ficam versionadas no GHCR.
FROM mautic/mautic:v4-apache

LABEL org.opencontainers.image.title="Mail XZ Mautic"
LABEL org.opencontainers.image.description="Mautic 4.4 customizado da Mail XZ (barra de uso de leads/disparos + personalizacoes)"
LABEL org.opencontainers.image.source="https://github.com/renatosouzadias/mailxz-mautic"

# Injeta o widget de uso (leads/disparos vs plano) no admin.
# Patch feito na FONTE (/usr/src/mautic) que o entrypoint copia pro volume do tenant.
# O sed casa </body> no template base do admin; o grep garante que a injecao aconteceu (falha o build se nao).
RUN set -e; \
    TPL=/usr/src/mautic/app/bundles/CoreBundle/Views/Default/base.html.twig; \
    test -f "$TPL"; \
    sed -i 's#</body>#    <script src="https://orquestrador.exz.digital/widget.js" defer></script>\n</body>#' "$TPL"; \
    grep -q 'orquestrador.exz.digital/widget.js' "$TPL"
