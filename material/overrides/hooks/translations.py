from mkdocs.plugins import BasePlugin

class CustomTranslationsPlugin(BasePlugin):
    def on_config(self, config, **kwargs):
        config['extra'] = {
            'translations': {
                'en': {'greeting': 'Hello'},
                'es': {'greeting': 'Hola'}
            }
        }
        return config
