import {Component, OnInit} from '@angular/core';
import {HelperService} from "../../../../../shared/helper.service";

@Component({
  selector: 'app-organizations-staff-view',
  templateUrl: './organizations-staff-view.component.html',
  styleUrls: ['./organizations-staff-view.component.css']
})
export class OrganizationsStaffViewComponent implements OnInit {
  constructor(public helperService: HelperService) { }

  ngOnInit(): void {

  }

}
