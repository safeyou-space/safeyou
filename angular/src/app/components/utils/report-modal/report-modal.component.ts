import {Component, Input, OnInit, ViewChild} from '@angular/core';
import {FormControl, FormGroup, Validators} from "@angular/forms";
import { ActivatedRoute } from '@angular/router';
import {ModalDirective} from "ngx-bootstrap/modal";
import { RequestService } from 'src/app/shared/request.service';
import { SocketConnectionService } from 'src/app/shared/socketConnection.service';
import { apiUrl, apiUrlChat, environment, prefix } from 'src/environments/environment.prod';
import {HelperService} from "../../../shared/helper.service";

@Component({
  selector: 'app-report-modal',
  templateUrl: './report-modal.component.html',
  styleUrls: ['./report-modal.component.css']
})
export class ReportModalComponent implements OnInit {

  @ViewChild('autoShownModal', { static: false }) autoShownModal: any = ModalDirective;
  formReport = new FormGroup({
    message: new FormControl('', Validators.required),
    category_id: new FormControl('', Validators.required),
    comment_id: new FormControl(''),
    forum_id: new FormControl(''),
    user_id:  new FormControl(''),
    room_key: new FormControl(''),
    comment: new FormControl('')
  });
  // @Input() data;
  isModalShown = false;
  itemList: any;
  selectedItems: any;
  settings = {};
  language: any;
  country: any;
  imageUrl = apiUrlChat;

  constructor(public helperService: HelperService, private request: RequestService, public activateRoute: ActivatedRoute, private socketConnect: SocketConnectionService) {
    this.language = this.activateRoute.snapshot.params['language'];
    this.country = this.activateRoute.snapshot.params['country'];
   }

  ngOnInit(): void {
    // this.itemList = [
    //   {"id":1,"itemName":"Հայոյանք"},
    //   {"id":2,"itemName":"Վիրավորանք"},
    // ];
    this.selectedItems = [];
    setTimeout(() => {
      this.settings = {
        text:this.helperService.translation?.select_category,
        selectAllText:'Select All',
        unSelectAllText:'UnSelect All',
        enableSearchFilter: true,
        classes:"myclass custom-class",
        showCheckbox: true,
        singleSelection: true,
        autoPosition: false,
      };
    },0);
  }

  commentInfo;

  showModal(comment?, type?): void {
    

    if (comment) {
      this.commentInfo = comment;
      this.formReport.controls['comment_id'].setValue(comment.message_id);
      if (!type) {
        this.formReport.controls['forum_id'].setValue(this.socketConnect.activeForumIdAndRoomKey['forumId']);
      }
      this.formReport.controls['room_key'].setValue(this.socketConnect.activeForumIdAndRoomKey['roomKey']);
      this.formReport.controls['user_id'].setValue(comment.message_send_by.user_id);

      if (comment.message_files.length > 0) {
        this.formReport.controls['comment'].setValue('sendet file');
      } else if (comment.message_content != null && comment.message_content != undefined ) {
        this.formReport.controls['comment'].setValue(comment.message_content);
      }

    }

    this.request.getData(`${environment.baseUrl}/${this.country}/${this.language}/${environment.admin.report.getAllCategories}`).subscribe(res => {
        this.itemList = [];
        for (let cat in res) {
            this.itemList.push({"id": cat, "itemName": res[cat]})
        }
    })

    this.isModalShown = true;
  }

  hideModal(): void {
    this.autoShownModal.hide();
    this.formReport.reset();
  }

  onHidden(): void {
    this.isModalShown = false;
  }
  onSubmitReport(form) {
    if (this.formReport.valid) {

      let formData = new FormData();
      for (let i in form) {
          if (i == 'category_id') {
              formData.append(i, form[i][0].id);
          } else if(i == 'forum_id') {
              if (form[i] != '' && form[i] != null && form[i] != undefined) {
                  formData.append(i, form[i]);
              }
          }
          else {
            formData.append(i,form[i]);
          }
      }

      this.request.createData(`${environment.baseUrl}/${this.country}/${this.language}/admin/report`, formData).subscribe(res => {
          this.hideModal();
      })

    } else {
      this.formReport.markAllAsTouched();
    }
  }

  closeDropdown (dropdownRef) {
    dropdownRef.closeDropdown();
  }

}
