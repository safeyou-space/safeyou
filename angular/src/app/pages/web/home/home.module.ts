import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import {HomeComponent} from "./home.component";
import {HomeRoutingModule} from "./home-routing.module";
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import {BsDropdownModule} from "ngx-bootstrap/dropdown";
import {ModalModule} from "ngx-bootstrap/modal";
import {CarouselModule} from "ngx-owl-carousel-o";

@NgModule({
  declarations: [HomeComponent],
  imports: [
    CommonModule,
    HomeRoutingModule,
    FormsModule,
    BsDropdownModule.forRoot(),
    ReactiveFormsModule.withConfig({warnOnNgModelWithFormControl: 'never'}),
    ModalModule.forRoot(),
    CarouselModule
  ]
})
export class HomeModule { }
