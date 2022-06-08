import {Component, forwardRef, Input, OnInit} from '@angular/core';
import {FormBuilder, NG_VALUE_ACCESSOR, Validators} from "@angular/forms";
import {HelperService} from "../../../shared/helper.service";

@Component({
  selector: 'app-date-input',
  templateUrl: './date-input.component.html',
  styleUrls: ['./date-input.component.css'],
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      multi: true,
      useExisting: forwardRef(() => DateInputComponent),
    }
  ]
})
export class DateInputComponent implements OnInit {
  @Input() setMinDate = true

  today = new Date();
  currentMonth = this.today.getMonth();
  currentYear = this.today.getFullYear();
  months: any = [];
  years: any = [];
  selectedDay = new Date();
  showDate: any;
  form = this.fb.group({
    date: ['', Validators.required]
  });
  constructor(private fb: FormBuilder,
              public helperService: HelperService) { }

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
    for (let i = 1970; i <= 2070; i++) {
      this.years.push(i);
    }
    setTimeout(()=> {
      this.showCalendar(this.currentMonth, this.currentYear);
    }, 0)
  }

  onChange: any = () => {}
  onTouch: any = () => {}
  registerOnChange(fn: any): void {
    this.onChange = fn;
  }
  registerOnTouched(fn: any): void {
    this.onTouch = fn;
  }

  writeValue(input: string) {
    if (input) {
      this.onChange(input);
      this.onTouch();
      this.selectedDay = new Date(input);
      this.showDate = this.selectedDay;
      this.today = new Date(input);
      this.currentMonth = this.today.getMonth();
      this.currentYear = this.today.getFullYear();
      this.showCalendar(this.currentMonth, this.currentYear);
    }else {
      this.selectedDay = new Date();
      this.today = new Date();
      this.showDate = undefined;
      this.currentMonth = this.today.getMonth();
      this.currentYear = this.today.getFullYear();
      this.showCalendar(this.currentMonth, this.currentYear);
    }
  }


  next () {
    this.currentYear = (this.currentMonth === 11) ? this.currentYear + 1 : this.currentYear;
    this.currentMonth = (this.currentMonth + 1) % 12;
    this.showCalendar(this.currentMonth, this.currentYear);
  }

  previous () {
    this.currentYear = (this.currentMonth === 0) ? this.currentYear - 1 : this.currentYear;
    this.currentMonth = (this.currentMonth === 0) ? 11 : this.currentMonth - 1;
    this.showCalendar(this.currentMonth, this.currentYear);
  }
  changeYear (year) {
    this.currentYear = year;
    this.showCalendar(this.currentMonth, this.currentYear);
  }
  changeMonth (month) {
    this.currentMonth = month;
    this.showCalendar(this.currentMonth, this.currentYear);
  }

  showCalendar(month, year) {

    let firstDay = (new Date(year, month)).getDay() - 1;

    let tbl = <HTMLElement>document.getElementById("calendar-body"); // body of the calendar

    tbl.innerHTML = "";

    let date = 1;
    for (let i = 0; i < 6; i++) {
      let row = document.createElement("tr");
      for (let j = 0; j < 7; j++) {
        if (i === 0 && j < firstDay) {
          let previousMonthDay = this.daysInMonth(month - 1, year) - (firstDay - j - 1);
          let cell = document.createElement("th");
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
              let	cell = document.createElement("th");
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
          let  cell = document.createElement("th");
          let  cellText = document.createTextNode(date.toString());
          let span = document.createElement('span');
          if (date === this.today.getDate() && year === this.today.getFullYear() && month === this.today.getMonth()) {
            span.classList.add("currentDay");
          }
          span.classList.add('change-Day');
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
    this.addCurrentDay();
  }

  addCurrentDay() {
    document.querySelectorAll('.change-Day').forEach((item) => {
      item.addEventListener('click',() => {
        let day = new Date().getDate() as any;
        let month = new Date().getMonth() as any;
        let year = new Date().getFullYear() as any;
        let count = Number(new Date(year, month, day))  - Number(new Date(this.currentYear, this.currentMonth, +item.innerHTML));
        if (this.setMinDate) {
          if (count >= 0) {
            if (document.querySelectorAll('.currentDay')[0]) {
              document.querySelectorAll('.currentDay')[0].classList.remove('currentDay')
            }
            item.classList.add('currentDay');
            this.today = new Date(this.currentYear, this.currentMonth, +item.innerHTML);
            this.selectedDay = new Date(this.currentYear, this.currentMonth, +item.innerHTML);
          }
        }
        if (!this.setMinDate) {
          if (count <= 0) {
            if (document.querySelectorAll('.currentDay')[0]) {
              document.querySelectorAll('.currentDay')[0].classList.remove('currentDay')
            }
            item.classList.add('currentDay');
            this.today = new Date(this.currentYear, this.currentMonth, +item.innerHTML);
            this.selectedDay = new Date(this.currentYear, this.currentMonth, +item.innerHTML);
          }
        }
      })
    })
  }
  setCurrentDay() {
    this.today = new Date();
    this.selectedDay = new Date();
    this.currentMonth = this.today.getMonth();
    this.currentYear = this.today.getFullYear();
    this.showCalendar(this.currentMonth, this.currentYear);
  }

  daysInMonth(iMonth, iYear) {
    return 32 - new Date(iYear, iMonth, 32).getDate();
  }
  save() {
    this.showDate = this.selectedDay;
    this.onChange(this.selectedDay);
    this.onTouch();
  }

}
