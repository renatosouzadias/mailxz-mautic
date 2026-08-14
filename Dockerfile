# Mail XZ — imagem Mautic customizada (golden image, versão fixa 4.4)
# Base oficial pinada; nossas personalizações vão aqui e ficam versionadas no GHCR.
FROM mautic/mautic:v4-apache

LABEL org.opencontainers.image.title="Mail XZ Mautic"
LABEL org.opencontainers.image.description="Mautic 4.4 customizado da Mail XZ (barra de uso de leads/disparos + personalizacoes)"
LABEL org.opencontainers.image.source="https://github.com/renatosouzadias/mailxz-mautic"

# Injeta o widget de uso (leads/disparos vs plano) no admin via mod_substitute do Apache.
# Feito no nível do HTTP (config na imagem, NÃO no volume) => imune a cache Twig/volume persistente.
# Injeta o <script> antes de </body> em toda resposta text/html.
RUN a2enmod substitute filter \
 && printf '%s\n' \
    'AddOutputFilterByType SUBSTITUTE text/html' \
    'Substitute "s|</body>|<script src=\"https://orquestrador.exz.digital/widget.js\" defer></script></body>|ni"' \
    > /etc/apache2/conf-available/mailxz-widget.conf \
 && a2enconf mailxz-widget \
 && apache2ctl configtest
