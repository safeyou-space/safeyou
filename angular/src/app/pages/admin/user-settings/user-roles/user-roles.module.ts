import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {SharedModule} from "../../../../components/shared.module";
import {ModalModule} from "ngx-bootstrap/modal";
import {UserRolesComponent} from "./user-roles.component";
import {UserRolesRoutingModule} from "./user-roles-routing.module";
import {BsDropdownModule} from "ngx-bootstrap/dropdown";
import { UserRolesViewComponent } from './user-roles-view/user-roles-view.component';
import { UserRolesCreateUpdateComponent } from './user-roles-create-update/user-roles-create-update.component';
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";
import {ReactiveFormsModule} from "@angular/forms";
import {TooltipModule} from "ngx-bootstrap/tooltip";
import {PaginationModule} from "ngx-bootstrap/pagination";
import { UserRolesCreateComponent } from './user-roles-create/user-roles-create.component';


@NgModule({
  declarations: [UserRolesComponent, UserRolesViewComponent, UserRolesCreateUpdateComponent, UserRolesCreateComponent],
  imports: [
    CommonModule,
    SharedModule,
    UserRolesRoutingModule,
    BsDropdownModule.forRoot(),
    ModalModule.forRoot(),
    AngularMultiSelectModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    TooltipModule.forRoot(),
    PaginationModule,
  ]
})
export class UserRolesModule { }
