export const apiUrl = '';
export const apiUrlChat = '';

export const prefix = '/api';

export const environment = {
  production: true,
  url: apiUrlChat + '',
  imagePrefix: apiUrl + '',
  baseUrl: apiUrl + prefix,
  SIGNAL_PROFILE: 0 , // public: we get it when you connect to server. */
  SIGNAL_CONNECTED: 1 , // public: we get it when new users connect to the server. */
  SIGNAL_DISCONNECTED: 2 , // public: we get it when users disconnect from the server. */
  SIGNAL_R_JOINED: 3 , // public: we get it when new users join to the room. */
  SIGNAL_R_LEAVED: 4 , // public: we get it when users leave from the room. */
  SIGNAL_R_INSERT: 5 , // public: we get it when we add a new room. */
  SIGNAL_R_UPDATE: 6 , // public: we get it when we edit a room. */
  SIGNAL_R_DELETE: 7 , // public: we get it when we delete a room. */
  SIGNAL_M_INSERT: 8 , // public: we get it when we send a new message in the room. */
  SIGNAL_M_UPDATE: 9 , // public: we get it when we edit a message in the room. */
  SIGNAL_M_DELETE: 10 , // public: we get it when we delete a message in the room. */
  SIGNAL_M_TYPING: 11 , // public: we get it when users type a message in the room. */
  SIGNAL_M_RECEIVED: 12 , // public: we get it when users view a message in the room. */
  SIGNAL_NOTIFICATION: 13 , // public: notification. */
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
      changeToConsultant: 'admin/user/change_to_consultant',
      blocked: 'admin/user/user_block',
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
    },
    push_notification: {
      getUserList: 'admin/user_list',
      get: 'firebase/user/notify/709EA4C1866EBEFC0191279FBE8BA162'
    }
  },
  web: {
    geolocation: {
      sendPhone: 'help/message/view'
    }
  }
};
