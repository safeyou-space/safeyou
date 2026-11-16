import {Component, OnInit} from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {getStyle, hexToRgba} from '@coreui/coreui/dist/js/coreui-utilities';
import {CustomTooltips} from '@coreui/coreui-plugin-chartjs-custom-tooltips';
import {RequestService} from "../../shared/Service/request.service";
import {environment} from "../../../environments/environment.prod";

@Component({
  templateUrl: 'dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {

  constructor(public router: Router,
              public activeRoute: ActivatedRoute,
              public requestService: RequestService) {
    this.requestService.activeCountryCode = this.activeRoute.snapshot.params['code'];
  }

  url: any;
  dashboardData: any;
  isLoaded: boolean = false;

  radioModel: string = 'Year';

  // lineChart1
  public lineChart1Data: Array<any> = [
    {
      data: [65, 59, 84, 84, 51, 55, 40],
      label: 'Series A'
    }
  ];
  public lineChart1Labels: Array<any> = ['Active', 'Inactive'];
  public lineChart1Options: any = {
    tooltips: {
      enabled: false,
      custom: CustomTooltips
    },
    maintainAspectRatio: false,
    scales: {
      xAxes: [{
        gridLines: {
          color: 'transparent',
          zeroLineColor: 'transparent'
        },
        ticks: {
          fontSize: 2,
          fontColor: 'transparent',
        }

      }],
      yAxes: [{
        display: false,
        ticks: {
          display: false,
          min: 1 - 5,
          max: 84 + 5,
        }
      }],
    },
    elements: {
      line: {
        borderWidth: 1
      },
      point: {
        radius: 4,
        hitRadius: 10,
        hoverRadius: 4,
      },
    },
    legend: {
      display: false
    }
  };
  public lineChart1Colours: Array<any> = [
    {
      backgroundColor: getStyle('--primary'),
      borderColor: 'rgba(255,255,255,.55)'
    }
  ];
  public lineChart1Legend = false;
  public lineChart1Type = 'line';

  // lineChart2
  public lineChart2Data: Array<any> = [
    {
      data: [1, 18, 9, 17, 34, 22, 11],
      label: 'Series A'
    }
  ];
  public lineChart2Labels: Array<any> = ['Active', 'Inactive', 'Blocked'];
  public lineChart2Options: any = {
    tooltips: {
      enabled: false,
      custom: CustomTooltips
    },
    maintainAspectRatio: false,
    scales: {
      xAxes: [{
        display: false,
        barPercentage: 0.6,
      }],
      yAxes: [{
        display: false,
        ticks: {
          steps : 5,
          stepValue : 5,
          max : 10,
          min: 0
        }
      }]
    },
    legend: {
      display: false
    }
  };
  public lineChart2Colours: Array<any> = [
    { // grey
      // backgroundColor: getStyle('--info'),
      backgroundColor: ['#5cb85c', '#d9534f', '#850400'],
      borderColor: 0
    }
  ];
  public lineChart2Legend = false;
  public lineChart2Type = 'bar';


  // lineChart3
  public lineChart3Data: Array<any> = [
    {
      data: [78, 81, 80, 45, 34, 12, 40],
      label: 'Series A'
    }
  ];
  public lineChart3Labels: Array<any> = ['Active', 'Inactive'];
  public lineChart3Options: any = {
    tooltips: {
      enabled: false,
      custom: CustomTooltips
    },
    maintainAspectRatio: false,
    scales: {
      xAxes: [{
        display: false
      }],
      yAxes: [{
        display: false
      }]
    },
    elements: {
      line: {
        borderWidth: 2
      },
      point: {
        radius: 0,
        hitRadius: 10,
        hoverRadius: 4,
      },
    },
    legend: {
      display: false
    }
  };
  public lineChart3Colours: Array<any> = [
    {
      backgroundColor: 'rgba(255,255,255,.2)',
      borderColor: 'rgba(255,255,255,.55)',
    }
  ];
  public lineChart3Legend = false;
  public lineChart3Type = 'line';


  // barChart1
  public barChart1Data: Array<any> = [
    {
      data: [78, 81, 80, 45, 34, 12, 40, 78, 81, 80, 45, 34, 12, 40, 12, 40],
      label: 'Series A'
    }
  ];
  public barChart1Labels: Array<any> = ['Active', 'Inactive', 'Hide'];
  public barChart1Options: any = {
    tooltips: {
      enabled: false,
      custom: CustomTooltips
    },
    maintainAspectRatio: false,
    scales: {
      xAxes: [{
        display: false,
        barPercentage: 0.6,
      }],
      yAxes: [{
        display: false,
        ticks: {
          steps : 5,
          stepValue : 5,
          max : 10,
          min: 0
        }
      }]
    },
    legend: {
      display: false
    }
  };
  public barChart1Colours: Array<any> = [
    {
      backgroundColor: ['#4dbd74', '#d9534f'],
      borderWidth: 0
    }
  ];
  public barChart1Legend = false;
  public barChart1Type = 'bar';

  // mainChart

  public mainChartElements = 27;
  public mainChartData1: Array<number> = [];

  public mainChartData: Array<any> = [
    {
      data: this.mainChartData1,
      label: 'Current'
    },
  ];
  /* tslint:disable:max-line-length */
  public mainChartLabels: Array<any> = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  /* tslint:enable:max-line-length */
  public mainChartOptions: any = {
    tooltips: {
      enabled: false,
      custom: CustomTooltips,
      intersect: true,
      mode: 'index',
      position: 'nearest',
      callbacks: {
        labelColor: function (tooltipItem, chart) {
          return {backgroundColor: chart.data.datasets[tooltipItem.datasetIndex].borderColor};
        }
      }
    },
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      xAxes: [{
        gridLines: {
          drawOnChartArea: false,
        },
        ticks: {
          callback: function(tick) {
            var characterLimit = 4;
            if ( tick.length >= characterLimit) {
              return tick.slice(0, tick.length).substring(0, characterLimit -1);
            }
            return tick;
          }
        }
      }],
      yAxes: [{
        ticks: {
          beginAtZero: true,
          maxTicksLimit: 5,
          stepSize: Math.ceil(250 / 5),
          max: 250
        }
      }]
    },
    elements: {
      line: {
        borderWidth: 2
      },
      point: {
        radius: 0,
        hitRadius: 10,
        hoverRadius: 4,
        hoverBorderWidth: 3,
      }
    },
    legend: {
      display: false
    }
  };
  public mainChartColours: Array<any> = [
    { // brandInfo
      backgroundColor: hexToRgba(getStyle('--info'), 10),
      borderColor: getStyle('--info'),
      pointHoverBackgroundColor: '#fff'
    },
    { // brandSuccess
      backgroundColor: 'transparent',
      borderColor: getStyle('--success'),
      pointHoverBackgroundColor: '#fff'
    },
    { // brandDanger
      backgroundColor: 'transparent',
      borderColor: getStyle('--danger'),
      pointHoverBackgroundColor: '#fff',
      borderWidth: 1,
      borderDash: [8, 5]
    }
  ];
  public mainChartLegend = false;
  public mainChartType = 'line';


  /*main chart data 1*/

  public mainChartData5: Array<any> = [
    {
      data: this.mainChartData,
      label: 'Current'
    },
  ];
  /* tslint:disable:max-line-length */
  public mainChartLabels5: Array<any> = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  /* tslint:enable:max-line-length */
  public mainChartOptions5: any = {
    tooltips: {
      enabled: false,
      custom: CustomTooltips,
      intersect: true,
      mode: 'index',
      position: 'nearest',
      callbacks: {
        labelColor: function (tooltipItem, chart) {
          return {backgroundColor: chart.data.datasets[tooltipItem.datasetIndex].borderColor};
        }
      }
    },
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      xAxes: [{
        gridLines: {
          drawOnChartArea: false,
        },
        ticks: {
          callback: function(tick) {
            var characterLimit = 4;
            if ( tick.length >= characterLimit) {
              return tick.slice(0, tick.length).substring(0, characterLimit -1);
            }
            return tick;
          }
        }
      }],
      yAxes: [{
        ticks: {
          beginAtZero: true,
          maxTicksLimit: 5,
          stepSize: Math.ceil(250 / 5),
          max: 250
        }
      }]
    },
    elements: {
      line: {
        borderWidth: 2
      },
      point: {
        radius: 0,
        hitRadius: 10,
        hoverRadius: 4,
        hoverBorderWidth: 3,
      }
    },
    legend: {
      display: false
    }
  };
  public mainChartColours5: Array<any> = [
    { // brandInfo
      backgroundColor: hexToRgba(getStyle('--info'), 10),
      borderColor: getStyle('--info'),
      pointHoverBackgroundColor: '#fff'
    },
    { // brandSuccess
      backgroundColor: 'transparent',
      borderColor: getStyle('--success'),
      pointHoverBackgroundColor: '#fff'
    },
    { // brandDanger
      backgroundColor: 'transparent',
      borderColor: getStyle('--danger'),
      pointHoverBackgroundColor: '#fff',
      borderWidth: 1,
      borderDash: [8, 5]
    }
  ];
  public mainChartLegend5 = false;
  public mainChartType5 = 'line';

  // social box charts

  public brandBoxChartData1: Array<any> = [
    {
      data: [65, 59, 84, 84, 51, 55, 40],
      label: 'Facebook'
    }
  ];
  public brandBoxChartData2: Array<any> = [
    {
      data: [1, 13, 9, 17, 34, 41, 38],
      label: 'Network'
    }
  ];
  public brandBoxChartData3: Array<any> = [
    {
      data: [78, 81, 80, 45, 34, 12, 40],
      label: 'Emergencies'
    }
  ];
  public brandBoxChartData4: Array<any> = [
    {
      data: [35, 23, 56, 22, 97, 23, 64],
      label: 'Consultants'
    }
  ];

  public brandBoxChartLabels: Array<any> = ['Active', 'Inactive'];
  public brandBoxChartOptions: any = {
    tooltips: {
      enabled: false,
      custom: CustomTooltips
    },
    responsive: true,
    maintainAspectRatio: false,
    scales: {
      xAxes: [{
        display: false,
      }],
      yAxes: [{
        display: false,
      }]
    },
    elements: {
      line: {
        borderWidth: 2
      },
      point: {
        radius: 0,
        hitRadius: 10,
        hoverRadius: 4,
        hoverBorderWidth: 3,
      }
    },
    legend: {
      display: false
    }
  };
  activeUsersAndMessages: any = {
    users: '2020',
    messages: '2020'
  };
  public brandBoxChartColours: Array<any> = [
    {
      backgroundColor: 'rgba(255,255,255,.1)',
      borderColor: 'rgba(255,255,255,.55)',
      pointHoverBackgroundColor: '#fff'
    }
  ];
  public brandBoxChartLegend = false;
  public brandBoxChartType = 'line';
  dateCount: any = [];

  public random(min: number, max: number) {
    return Math.floor(Math.random() * (max - min + 1) + min);
  }

  ngOnInit(): void {
    let oldYear: any = new Date('2020');
    let currentYear: any = new Date();
    let betweenData = currentYear.getFullYear() - oldYear.getFullYear();
    for (let i = currentYear - betweenData; i <= currentYear; i++) {
      this.dateCount.push({'current': currentYear.getFullYear() - (currentYear - i)})
    }
    // generate random values for mainChart
    if (this.requestService.userInfo.isSuperAdmin == 'true' || this.requestService.userInfo.isAdmin == 'true') {
      this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.dashboard.get}`;
      this.requestService.getData(this.url).subscribe((res: any) => {
        this.mainChartData1.splice(0);
        this.mainChartData5.splice(0);
        this.brandBoxChartData1.splice(0);
        this.lineChart2Data.splice(0);
        this.brandBoxChartData3.splice(0);
        this.brandBoxChartData4.splice(0);
        this.barChart1Data.splice(0);
        this.brandBoxChartData2.splice(0);
        this.dashboardData = res;
        this.lineChart2Options.scales.yAxes[0].ticks.max = Math.max(Number(res.users.active), Number(res.users.inactive), Number(res.users.blocked));
        this.barChart1Options.scales.yAxes[0].ticks.max = Math.max(Number(res.forums.active), Number(res.forums.inactive), Number(0));
        this.brandBoxChartData1.push({
          data: [Number(res.consultants.active), Number(res.consultants.inactive)],
          label: 'Consultant'
        });
        this.brandBoxChartData2.push({
          data: [Number(res.network_categories.active), Number(res.network_categories.inactive)],
          label: 'Network'
        });
        this.lineChart2Data.push({
          data: [Number(res.users.active), Number(res.users.inactive), Number(res.users.blocked)],
          label: 'Users'
        });
        this.brandBoxChartData3.push({
          data: [Number(res.emergencies.active), Number(res.emergencies.inactive)],
          label: 'Emergencies'
        });
        this.brandBoxChartData4.push({
          data: [Number(res.consultants.active), Number(res.consultants.inactive)],
          label: 'Consultants'
        });
        this.barChart1Data.push({
          data: [Number(res.forums.active), Number(res.forums.inactive), Number(0)],
          label: 'Forums'
        });
        for (let i in res.reg_users_by_month) {
          this.mainChartData1.push(res.reg_users_by_month[i]);
        }
        let arr = [];
        for (let i in res.help_messages) {
          arr.push(res.help_messages[i]);
        }
        this.mainChartData5.push({
          data: arr,
          label: 'Help Messages'
        })
        this.isLoaded = true;
      }, (error) => {
        this.requestService.StatusCode(error);
      });
    }
  }

  getYearChartData(year, type) {
    this.url = `${environment.endpoint}${this.requestService.activeCountryCode}${environment.dashboard.get}?year=${year}`;
    this.requestService.getData(this.url).subscribe((res: any) => {
      if (type == 'users') {
        this.mainChartData1 = [];
        this.mainChartData = [];
        this.activeUsersAndMessages['users'] = year;
        for (let i in res.reg_users_by_month) {
          this.mainChartData1.push(res.reg_users_by_month[i]);
        }
        this.mainChartData.push({
          data: this.mainChartData1,
          label: 'Users'
        });
      } else {
        this.mainChartData5 = [];
        this.activeUsersAndMessages['messages'] = year;
        let arr = [];
        for (let i in res.help_messages) {
          arr.push(res.help_messages[i]);
        }
        this.mainChartData5.push({
          data: arr,
          label: 'Help Messages'
        });
      }
    }, (error) => {
      this.requestService.StatusCode(error);
    });
  }
}
