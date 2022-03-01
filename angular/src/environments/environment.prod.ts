export const apiUrl = '';
export const apiUrlChat = '';

export const prefix = '/api';

export const environment = {
  production: true,
  url: apiUrlChat + '',
  imagePrefix: apiUrl + '',
  baseUrl: apiUrl + prefix,
  SIGNAL_PROFILE: 0 ,
  SIGNAL_CONNECTED: 1 ,
  SIGNAL_DISCONNECTED: 2 ,
  SIGNAL_R_JOINED: 3 ,
  SIGNAL_R_LEAVED: 4 ,
  SIGNAL_R_INSERT: 5 ,
  SIGNAL_R_UPDATE: 6 ,
  SIGNAL_R_DELETE: 7 ,
  SIGNAL_M_INSERT: 8 ,
  SIGNAL_M_UPDATE: 9 ,
  SIGNAL_M_DELETE: 10 ,
  SIGNAL_M_TYPING: 11 ,
  SIGNAL_M_RECEIVED: 12 ,
  SIGNAL_NOTIFICATION: 13 ,
  SIGNAL_M_LIKED: 16,
  SIGNAL_HELP: 15,
  SIGNAL_NOTIFICATIONMAIN: 17,
  admin: {
    refresh: 'admin/refresh',
    login: 'admin/login',
    getLanguageList: 'languages',
    getCountryList: 'countries',
    logout: 'admin/logout',
    communication: apiUrlChat + prefix + '/rooms/',
    friendsList: apiUrlChat + prefix + '/friends/list',
    marital_statuses: 'marital_statuses',
    forgotPassword: 'admin/forgot_password',
    createPassword: 'admin/create_password',
    registration: 'admin/registration',
    dashboard: 'admin/dashboard',
    content: {
      get: 'admin/content'
    },
    appUsers: {
      get: 'admin/user',
      changeStatus: 'admin/user/change_status',
      changeToConsultant: 'admin/user/change_to_consultant'
    },
    appAdmin: {
      get: 'admin/admin'
    },
    consultants: {
      get: 'admin/consultant',
      getProfessionList: 'admin/consultant_service_category',
      changeStatus: 'admin/consultant/change_status',
      consultantRequest: 'admin/request_consultant',
      getMaritalStatusList: 'marital_statuses',
      changeToAppUser: 'admin/consultant/reject'
    },
    organization: {
      get: 'admin/emergency_service',
      getCategoryList: 'admin/emergency_service_category',
      changeStatus: 'admin/emergency_service/change_status',
      getAllCategoryList: 'admin/emergency_service_category/list',
      profileNgo: 'admin/user/emergency/profile'
    },
    forum: {
      get: 'admin/forum',
      getCategory: 'admin/forum/category',
      getAllCategoryList: 'admin/forum_category/list'
    },
    sms: {
      get: 'admin/sms'
    },
    rate: {
      get: 'admin/rate'
    },
    report: {
      get: 'admin/report',
      getCategoryList: 'admin/report/categories',
      getAllCategories: 'admin/report/category/list'
    },
    profile: {
      get: 'admin/user/profile',
      changePassword: 'admin/user/profile/change_password'
    },
    settings: {
      get: 'admin/setting',
    },
    helpMessages: {
      get: 'admin/help_message'
    },
    translations: {
      get: 'admin/translation'
    },
    beneficiary: {
      get: 'admin/beneficiaries'
    },
    languages: {
      get: 'admin/language',
      getApplication: 'admin/language'
    }
  },
  web: {
    geolocation: {
      sendPhone: 'help/message/view'
    }
  }
};
