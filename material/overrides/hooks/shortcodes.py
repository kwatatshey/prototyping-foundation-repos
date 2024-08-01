# material/overrides/hooks/shortcodes.py

# Remove the faulty import
# from mkdocs.utils import warning

from mkdocs.plugins import BasePlugin

class CustomShortcodesPlugin(BasePlugin):
    def on_page_context(self, context, page, config, files):
        context['custom_variable'] = 'value'

    def on_config(self, config, **kwargs):
        config['extra_css'] = ['css/custom.css']
        return config
