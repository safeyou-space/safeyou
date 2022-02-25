import {Component, Input, OnInit, ViewChild} from '@angular/core';
import {ModalDirective} from "ngx-bootstrap/modal";
import {HelperService} from "../../../shared/helper.service";

@Component({
  selector: 'app-info-modal',
  templateUrl: './info-modal.component.html',
  styleUrls: ['./info-modal.component.css']
})
export class InfoModalComponent implements OnInit {

  @Input() signalData;
  @Input() data;
  @Input() index;
  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  isModalShown = false;
  itemList: any;
  selectedItems: any;
  settings = {};
  showMap = false;
  birthday;
  address;
  months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
  helpSmsDate;
  time;
  hours;
  minutes;
  seconds;

  constructor(public helperService: HelperService) { }

  ngOnInit(): void {
  }

  getAge(dateString) {
    let today = new Date();
    let birthDate = new Date(dateString);
    let age = today.getFullYear() - birthDate.getFullYear();
    let m = today.getMonth() - birthDate.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate()))
    {
        age--;
    }
    return age;
  }




  showModal(): void {
    this.isModalShown = true;
    setTimeout(()=>{
      if (this.data) {
        this.signalData = this.data;
      }
      if (typeof this.index != 'number' && !this.data) {
        this.index = 0;
      }
      this.signalData.help_sms[this.index].created_at = new Date(this.signalData.help_sms[this.index].created_at);

      this.birthday = this.getAge(this.signalData?.birthday);
      this.address = this.signalData?.help_sms[this.index].message.split('\n');
      this.address = this.address[3].split('<br/>');
      this.address = this.address[0];
      let day = this.signalData.help_sms[this.index].created_at.getDate();
      let year = this.signalData.help_sms[this.index].created_at.getFullYear();
      let month = this.months[this.signalData.help_sms[this.index].created_at.getMonth()];
      this.helpSmsDate = day + ' ' + month + ', ' + year;
      this.hours = this.signalData.help_sms[this.index].created_at.getHours();
      this.minutes = this.signalData.help_sms[this.index].created_at.getMinutes();
      this.seconds = this.signalData.help_sms[this.index].created_at.getSeconds();
      this.time = this.signalData.help_sms[this.index].created_at.getHours() + ":" + this.signalData.help_sms[this.index].created_at.getMinutes() + ":" + this.signalData.help_sms[this.index].created_at.getSeconds();
    }, 0);


    setTimeout(() => {
      this.showMap = true;
    }, 200)
  }

  hideModal(): void {
    this.autoShownModal.hide();
    this.isModalShown = false;
    this.showMap = false;
  }

  onHidden(): void {
    this.isModalShown = false;
    this.showMap = false;
    this.signalData = undefined;
    this.data = undefined;
    this.index = undefined;

  }

  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }

}
