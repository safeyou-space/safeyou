import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { UserInviteRoutingModule } from './user-invite-routing.module';
import { UserInviteComponent } from './user-invite.component';
import {SharedModule} from "../../../components/shared.module";
import {ReactiveFormsModule} from "@angular/forms";
import {AngularMultiSelectModule} from "angular2-multiselect-dropdown";


@NgModule({
  declarations: [
    UserInviteComponent
  ],
  imports: [
    CommonModule,
    UserInviteRoutingModule,
    SharedModule,
    ReactiveFormsModule,
    AngularMultiSelectModule,
  ]
})
export class UserInviteModule { }
