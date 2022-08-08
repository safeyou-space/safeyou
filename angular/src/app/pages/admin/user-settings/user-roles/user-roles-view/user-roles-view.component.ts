import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {UserRolesComponent} from "../user-roles.component";
import {RequestService} from "../../../../../shared/request.service";
import {HelperService} from "../../../../../shared/helper.service";

@Component({
  selector: 'app-user-roles-view',
  templateUrl: './user-roles-view.component.html',
  styleUrls: ['./user-roles-view.component.css']
})
export class UserRolesViewComponent implements OnInit {
  @Output() myEvent = new EventEmitter();
  @Input() viewData;
  constructor(public requestService: RequestService,
              public helperService: HelperService) { }

  ngOnInit(): void {

  }

  editData(id) {
    UserRolesComponent.instance.createOrEdit('edit', id);
  }

  close(){
    this.myEvent.emit('close')
  }
}
