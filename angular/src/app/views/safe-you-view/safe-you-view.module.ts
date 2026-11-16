import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {BsDatepickerModule, BsDropdownModule, ModalModule, PaginationModule} from 'ngx-bootstrap';
import {SharedModule} from '../error/shared.module';
import {SafeYouViewComponent} from "./safe-you-view.component";
import {SafeYouViewRoutingModule} from "./safe-you-view-routing.module";
import {AlertModule} from "ngx-alerts";
import {BrowserAnimationsModule} from "@angular/platform-browser/animations";

@NgModule({
  declarations: [SafeYouViewComponent],
  imports: [
    CommonModule,
    SafeYouViewRoutingModule,
    ModalModule.forRoot(),
    FormsModule,
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    SharedModule,
    PaginationModule.forRoot(),
    BsDatepickerModule.forRoot(),
    BsDropdownModule.forRoot(),
    AlertModule.forRoot({maxMessages: 5, timeout: 5000, position: 'right'}),
  ]
})
export class SafeYouViewModule { }
