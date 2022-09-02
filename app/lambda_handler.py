from src.infrastructure.logger import logger
from src.usecase import complete_vulnerabilities_loader


def handler(event, context):
    try:
        logger.info('Loading started...')
        complete_vulnerabilities_loader.load()
        logger.info('Loading completed successfully')
    except Exception as e:
        logger.error(e)
        raise


if __name__ == '__main__':
    handler('', '')
