export const endpoint = '/api/';

export const environment = {
  production: false,
  endpoint: '/api/',
  login: '/admin/login',
  logout: '/admin/logout',
  refresh: '/admin/refresh',
  resetPassword: {
    get: '/admin/user/profile'
  },
  dashboard: {
    get: '/admin/dashboard'
  },
  contactUs: {
    createContactUs: 'arm/en/contact_us',
    getContactUsActiveList: '/admin/email/unchecked_list',
    getContactList: '/admin/contact_us',
    isRead: '/admin/email/change_status/',
    answerContactUs: '/admin/email/response_letter'
  },
  geolocation: {
    sendPhone: '/help/message/view'
  },
  users: {
    get: '/admin/user',
    getNgo: '/admin/user/ngos',
    getVolunteer: '/admin/user/volunteers',
    getLegalService: '/admin/user/legal_services',
    getEmergencyContacts: '/admin/user/emergency_contacts',
    ngo: '/admin/user/ngo',
    volunteer: '/admin/user/volunteer',
    legalService: '/admin/user/legal_service',
    emergencyContacts: '/admin/user/emergency_contact',
    deleteEmergencyContacts: '/admin/user/emergency_contact',
    listNgo: '/admin/ngos_list',
    listVolunteer: '/admin/volunteers_list',
    listLegalService: '/admin/legal_services_list',
    getRecords: '/admin/user/records',
    records: '/admin/user/record',
    addDetail: '/admin/user/emergency_service_contact',
    deleteDetail: '/admin/user/emergency_service_contact',
    getImageProfile: '/admin/default_image/user_profile',
    maritalStatusList: '/admin/marital_status/list',

    emergencyServiceList: '/admin/user/emergency_services_list',
    emergencyServiceSelectedList: '/admin/user/emergency_services',
    getConsultantList: '/admin/consultant_service_category/list',
    changeConsultant: '/admin/user/change_to_consultant'
  },
  administration: {
    get: '/admin/admin',
    getImageProfile: '/admin/default_image/admin_profile',
  },
  lawyers: {
    get:  '/admin/lawyer'
  },
  legalService: {
    get:  '/admin/legal_service',
    getImageProfile: '/admin/default_image/legal_service_profile',
  },
  forum: {
    get:  '/admin/forum',
    deleteComment:  '/admin/forum/delete/comment',
    getImageProfile: '/admin/default_image/forum',
  },
  clientPage: {
    get:  '/admin/client',
    lawyerList: '/admin/lawyer_list',
    organizationList: '/admin/organization_list',
    configList: '/admin/config_list'
  },
  volunteer: {
    get: '/admin/volunteer',
    getImageProfile: '/admin/default_image/volunteer_profile',
  },
  ngo: {
    get: '/admin/ngo',
    getImageProfile: '/admin/default_image/ngo_profile',
  },
  hotlines: {
    get: '/admin/hotlines',
  },
  groups: {
    get: '/admin/chat_rooms',
    getAllMessages: '/admin/get_all_messages',
    deleteChatMessages: '/admin/chat_messages'
  },
  languages: {
    get: '/admin/language',
    getImageProfile: '/admin/default_image/language_flag',
  },
  content: {
    get: '/admin/content'
  },

  countryList: {
    get: 'arm/admin/country_list',
  },
  emergencyServiceCategory: {
    get: '/admin/emergency_service_category',
    getLanguageList: '/admin/language_list'
  },
  emergencyService: {
    get: '/admin/emergency_service',
    getIconsList: '/admin/image_social_icons',
    getImageProfile: '/admin/default_image/emergency_service_profile',
    emergencyServiceCategoryList: '/admin/emergency_service_category/list',
    isSendSms: '/admin/emergency_service/change_is_send_sms_status'
  },
  helpMessages: {
    get: '/admin/help_message',
    getLanguageList: '/admin/language_list'
  },
  consultants: {
    get: '/admin/consultant',
    getLanguageList: '/admin/language_list',
    getImageProfile: '/admin/default_image/consultant_service_profile',
    maritalStatusList: '/admin/marital_status/list',
    getConsultantCategoryList: '/admin/consultant_service_category/list'
  },
  categoryConsultants: {
    get: '/admin/consultant_service_category',
    getLanguageList: '/admin/language_list'
  },
  consultantsRequest: {
    get: '/admin/request_consultant',
  },
  sms: {
    get: '/admin/sms'
  },
  settings: {
    get: '/admin/setting',
    getLanguageList: '/admin/language_list'
  }
};


const endpointSocket = '';

export const environmentSocket = {
  socket_url_arm: endpointSocket + ':444/',
  socket_url_geo: endpointSocket + ':8081/',
 };
