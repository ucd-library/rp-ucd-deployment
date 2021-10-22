const utils = require(`@ucd-lib/cork-ci`);

// Application Version
const APP_VERSION = 'v1.4.0-alpha';
// Main App Tag
const VESSEL_TAG = 'sandbox'
const CLIENT_TAG = 'sandbox';
const HARVEST_TAG = 'dev';

const BUILD = utils.fileValue('/config/.buildenv', -1);
const CONTAINER_REG_ORG = 'gcr.io/ucdlib-pubreg';



module.exports = {
  version : `${APP_VERSION}.${BUILD}`,
  images : {

  },
  repositories : {

  }
}