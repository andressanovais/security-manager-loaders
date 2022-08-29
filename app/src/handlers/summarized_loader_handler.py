import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def handler(event, context):
    try:
        logger.info('lala')
    except Exception as e:
        logging.info(e)
