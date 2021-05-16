interface NavAttributes {
  [propName: string]: any;
}
interface NavWrapper {
  attributes: NavAttributes;
  element: string;
}
interface NavBadge {
  text: string;
  variant: string;
}
interface NavLabel {
  class?: string;
  variant: string;
}

export interface NavData {
  name?: string;
  url?: string;
  uri?: string;
  icon?: string;
  key?: string;
  badge?: NavBadge;
  title?: boolean;
  children?: NavData[];
  variant?: string;
  attributes?: NavAttributes;
  divider?: boolean;
  class?: string;
  label?: NavLabel;
  wrapper?: NavWrapper;
}

export const navItems: NavData[] = [
  {
    name: 'Dashboard',
    url: `/dashboard`,
    uri: `/dashboard`,
    key: `dashboard`,
    icon: 'icon-speedometer',
  },
  {
    name: 'Forums',
    url: '/forum',
    uri: '/forum',
    key: `forum`,
    icon: 'icon-bubbles'
  },
  {
    name: 'Users',
    url: '/users',
    uri: '/users',
    key: 'users',
    icon: 'icon-user-female',
  },
  {
    name: 'Emergencies',
    url: '/forum',
    icon: 'icon-globe-alt',
    children: [
      {
        name: 'Services',
        url: '/emergency-service',
        uri: '/emergency-service',
        key: 'emergency_service',
        icon: 'icon-people'
      },
      {
        name: 'Network Categories',
        url: '/network-category',
        uri: '/network-category',
        key: 'emergency_service_category',
        icon: 'icon-layers'
      }
    ]
  },
  {
    name: 'Help Messages',
    url: '/help-message',
    uri: '/help-message',
    key: 'help_message',
    icon: 'icon-speech',
  },
  {
    name: 'Consultants',
    url: '/forum',
    icon: 'icon-earphones-alt',
    children: [
      {
        name: 'Consultants',
        url: '/consultants',
        uri: '/consultants',
        key: 'consultants',
        icon: 'icon-people'
      },
      {
        name: 'Categories',
        url: '/category-consultants',
        uri: '/category-consultants',
        key: 'Categories',
        icon: 'icon-layers'
      },
      {
        name: 'Requests',
        url: '/consultant-requests',
        uri: '/consultant-requests',
        key: 'consultant_requests',
        icon: 'icon-call-in'
      }
    ]
  },
  {
    name: 'Contents',
    url: `/contents`,
    uri: `/contents`,
    key: `contents`,
    icon: 'icon-doc',
  },
  {
    name: 'Sms',
    url: '/sms',
    uri: '/sms',
    key: 'sms',
    icon: 'icon-screen-smartphone',
  },
  {
    name: 'Administrations',
    url: '/administration',
    uri: '/administration',
    key: `administration`,
    icon: 'icon-user',
  },

  {
    name: 'Languages',
    url: '/languages',
    uri: '/languages',
    key: 'languages',
    icon: 'icon-globe',
  },
  {
    name: 'Settings',
    url: '/settings',
    uri: '/settings',
    key: 'settings',
    icon: 'icon-settings',
  },
  {
    divider: true
  }
];
