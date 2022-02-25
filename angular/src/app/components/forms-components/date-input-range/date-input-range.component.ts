import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {HelperService} from "../../../shared/helper.service";

@Component({
  selector: 'app-date-input-range',
  templateUrl: './date-input-range.component.html',
  styleUrls: ['./date-input-range.component.css']
})
export class DateInputRangeComponent implements OnInit {

  @Output() saveDateRange = new EventEmitter();
  today = new Date();
  nextDay;
  selectedDay;
  form: any;
  currentMonth = this.today.getMonth();
  currentYear = this.today.getFullYear();
  nextMonth = this.today.getMonth();
  nextYear = this.today.getFullYear();
  months: any = [];

  constructor(public helperService: HelperService) { }

  ngOnInit(): void {
    this.months = [
      this.helperService.translation?.January,
      this.helperService.translation?.February,
      this.helperService.translation?.March,
      this.helperService.translation?.April,
      this.helperService.translation?.May,
      this.helperService.translation?.June,
      this.helperService.translation?.July,
      this.helperService.translation?.August,
      this.helperService.translation?.September,
      this.helperService.translation?.October,
      this.helperService.translation?.November,
      this.helperService.translation?.December,
    ];
    setTimeout(()=> {
      let tbl2 = <HTMLElement>document.getElementById("calendar-table-body");
      this.next();
      this.showCalendar(this.currentMonth , this.currentYear, tbl2, 'calendar-table-body');
    }, 0)
  }

  next () {
    let tbl = <HTMLElement>document.getElementById("calendar-table-body-2");
    this.nextYear = (this.nextMonth === 11) ? this.nextYear + 1 : this.nextYear;
    this.nextMonth = (this.nextMonth + 1) % 12;
    this.showCalendar(this.nextMonth, this.nextYear, tbl, 'calendar-table-body-2');
  }

  previous () {
    let tbl2 = <HTMLElement>document.getElementById("calendar-table-body");
    this.currentYear = (this.currentMonth === 0) ? this.currentYear - 1 : this.currentYear;
    this.currentMonth = (this.currentMonth === 0) ? 11 : this.currentMonth - 1;
    this.showCalendar(this.currentMonth, this.currentYear, tbl2, "calendar-table-body");
  }

  showCalendar(month, year, tbl?, type?) {

    let firstDay = (new Date(year, month)).getDay() - 1;
    tbl.innerHTML = "";
    let date = 1;
    for (let i = 0; i < 6; i++) {
      let row = document.createElement("div");
      row.classList.add('calendar-row');
      for (let j = 0; j < 7; j++) {
        if (i === 0 && j < firstDay) {
          let previousMonthDay = this.daysInMonth(month - 1, year) - (firstDay - j - 1);
          let cell = document.createElement("div");
          let span = document.createElement('span');
          let cellText = document.createTextNode(previousMonthDay.toString());
          span.classList.add('old-days');
          cell.appendChild(span);
          span.appendChild(cellText);
          row.appendChild(cell);
        }
        else if (date > this.daysInMonth(month, year)) {
          let emptyCount = 7 - row.childElementCount;
          if (j != 0) {
            for (let a = 0; a < emptyCount; a++) {
              let	cell = document.createElement("div");
              let span = document.createElement('span');
              let	cellText = document.createTextNode((a + 1).toString());
              span.classList.add('old-days');
              cell.appendChild(span);
              span.appendChild(cellText);
              row.appendChild(cell);
            }
          }
          break;
        }
        else {
          let  cell = document.createElement("div");
          let  cellText = document.createTextNode(date.toString());
          let span = document.createElement('span');
          if (date === this.today.getDate() && year === this.today.getFullYear() && month === this.today.getMonth()) {
            span.classList.add("current-day");
          }
          span.classList.add('changeDay');
          span.setAttribute('data-month', month);
          span.setAttribute('data-year', year);
          span.appendChild(cellText);
          cell.appendChild(span);
          row.appendChild(cell);
          date++;
        }
      }
      if (row.childElementCount != 0) {
        tbl.appendChild(row);
      }

    }
    this.addCurrentDay(type);
  }

  addCurrentDay(table) {
    document.querySelectorAll(`#${table} .changeDay`).forEach((item) => {
      item.addEventListener('click',() => {
        if (item.classList.contains('current-day')) {
         item.classList.remove('current-day');
        } else {
          item.classList.add('current-day');
          let el = document.querySelectorAll('.current-day');
           if (el.length == 3) {
             el[1].classList.remove('current-day');
           }
           if (el.length == 2 || el.length == 3) {
             this.addStyle();
           }
        }
        let days = document.querySelectorAll('.current-day');
        if (days.length == 1 || days.length == 0) {
          let el = document.querySelectorAll('.changeDay');
          el.forEach((item: any) => {
            if (item.parentElement.classList.contains('selected-bg')) {
              item.parentElement.classList.remove( ...item.parentElement.classList);
            } else if (item.parentElement.classList.contains('start-Day')) {
              item.parentElement.classList.remove('start-Day');
            } else if (item.parentElement.classList.contains('end-Day')) {
              item.parentElement.classList.remove('end-Day');
            }
          })
        }
      })
    })
  }


  addStyle() {
    let startDay = document.querySelectorAll('.current-day')[0];
    let nextDay = document.querySelectorAll('.current-day')[1];
    this.nextDay = new Date((nextDay.getAttribute('data-year') as any), (nextDay.getAttribute('data-month') as any), +nextDay.innerHTML);
    this.selectedDay = new Date(this.currentYear, (startDay.getAttribute('data-month') as any), +startDay.innerHTML);
    let el = document.querySelectorAll('.changeDay');
    let i = 1;
    for(let j = 0; j < el.length; j++) {
      let item = el[j] as any;
      if (i > 1 || item.classList.contains('current-day')) {
        if (item.getAttribute('data-month') == startDay.getAttribute('data-month') && item.innerHTML ==  startDay.innerHTML) {
          item.parentElement.classList.add('start-Day');
        } else if (item.getAttribute('data-month') == nextDay.getAttribute('data-month') && item.innerHTML ==  nextDay.innerHTML) {
          item.parentElement.classList.add('end-Day');
          break;
        } else {
          item.parentElement.classList.add('selected-bg');
        }
         ++i;
      }
    }
  }

  setCurrentDay() {
    let tbl2 = <HTMLElement>document.getElementById("calendar-table-body");
    this.today = new Date();
    this.selectedDay = new Date();
    this.nextDay = null;
    this.currentMonth = this.today.getMonth();
    this.currentYear = this.today.getFullYear();
    this.nextYear = this.today.getFullYear();
    this.nextMonth = this.today.getMonth();
    this.showCalendar(this.currentMonth, this.currentYear, tbl2, 'calendar-table-body');
    this.next();
    this.saveDateRange.emit(null);
  }

  daysInMonth(iMonth, iYear) {
    return 32 - new Date(iYear, iMonth, 32).getDate();
  }
  clear() {
    let tbl2 = <HTMLElement>document.getElementById("calendar-table-body");
    this.today = new Date();
    this.selectedDay = null;
    this.nextDay = null;
    this.currentMonth = this.today.getMonth();
    this.currentYear = this.today.getFullYear();
    this.nextYear = this.today.getFullYear();
    this.nextMonth = this.today.getMonth();
    this.showCalendar(this.currentMonth, this.currentYear, tbl2, "calendar-table-body");
    this.next();
    this.saveDateRange.emit(null);
  }

  save() {
    let days = document.querySelectorAll('.current-day') as any;
    if (this.selectedDay && this.nextDay && days.length == 2) {
      let formFilter = `&from=${this.selectedDay.getFullYear()}-${this.selectedDay.getMonth() + 1}-${this.selectedDay.getDate()}` +
      `&to=${this.nextDay.getFullYear()}-${this.nextDay.getMonth() + 1}-${this.nextDay.getDate()}`;
      this.saveDateRange.emit([this.selectedDay, this.nextDay, formFilter]);
    }
    if (days.length == 1) {
      let year = days[0].getAttribute('data-year');
      let month = days[0].getAttribute('data-month');
      let day = days[0].innerText;
      let formFilter = `&from=${year}-${+month + 1}-${day}` +
        `&to=${year}-${+month + 1}-${day}`;
      this.saveDateRange.emit(['', '', formFilter]);
    }
  }
}
