import {Injectable} from '@angular/core';
import {BehaviorSubject, Subject} from 'rxjs';
import {AbstractControl, FormGroup} from "@angular/forms";
import  {translations} from "../../assets/language/translation";
import { Location } from '@angular/common';
import {ActivatedRoute, Router} from "@angular/router";

@Injectable({
  providedIn: 'root'
})
export class HelperService {
  public invokeEvent: Subject<any> = new Subject();
  public menuItem: Subject<any> = new Subject();
  translation: any;
  defaultLanguage: any = localStorage.getItem('shortCode') ? localStorage.getItem('shortCode') : 'en';
  loginTranslations: any = translations[this.defaultLanguage];
  languageList: any;
  activeLanguage: any;
  show404: Subject<any> = new BehaviorSubject(true);

  userName: any = `${localStorage.getItem('first_name')}`;
  userLastName: any = `${localStorage.getItem('last_name')}`;
  userEmail: any = `${localStorage.getItem('email')}`;
  userImage: any = `${localStorage.getItem('image')}`;
  role = localStorage.getItem('role')!;
  forumGet: Subject<any> = new Subject();

  callMethodOfSecondComponent(bool) {
    this.invokeEvent.next(bool);
  }


  changeMenuItem(value) {
    this.menuItem.next(value);
  }

  getNavigateForum(forum) {
    this.forumGet.next(forum);
  }

  constructor(private location: Location,
              public router: Router,
              public activeRoute: ActivatedRoute) {
  }

  matchingPasswords(passwordKey: string, passwordConfirmationKey: string) {
    return (group: FormGroup) => {
      let password= group.controls[passwordKey];
      let passwordConfirmation= group.controls[passwordConfirmationKey];
      if (password.value !== passwordConfirmation.value) {
        return passwordConfirmation.setErrors({mismatchedPasswords: true})
      }
    }
  }

  changeLanguage(lang) {
    this.translation = translations[lang];
    this.defaultLanguage = lang;
    localStorage.setItem('shortCode', this.defaultLanguage);
    let country = this.location['_platformLocation'].location.pathname.split('/')[1];
    let language = lang;
    let activeUrl = this.location['_platformLocation'].location.pathname.split('/')[3];
    let activeUrl2 = this.location['_platformLocation'].location.pathname.split('/')[4] ? this.location['_platformLocation'].location.pathname.split('/')[4] : '';
    this.location.replaceState(country + '/' + language + '/' + activeUrl + '/' + activeUrl2);
    let currentUrl = country + '/' + language + '/' + activeUrl + '/' + activeUrl2;
    this.router.navigateByUrl('/' + currentUrl, { skipLocationChange: true }).then(() => {
      this.router.navigate([currentUrl]);
    });
  }

  activeLanguageChange(item) {
    this.activeLanguage = item;
  }

  removeSpaces(control: AbstractControl) {
    if (control && control.value && !control.value.replace(/\s/g, '').length) {
      control.setValue('');
    }
    return null;
  }

  _getWords(data) {
    const txt = this.modelElementToPlainText( data );
    const detectedWords = txt.match( /([\p{L}\p{N}0-9]+\S?)+/gu ) || [];

    return detectedWords.length;
  }

  _getCharacters(data) {
    const txt = this.modelElementToPlainText( data );

    return txt.replace( /\n/g, '' ).length;
  }

  modelElementToPlainText( element ) {
    if ( element.is( '$text' ) || element.is( '$textProxy' ) ) {
      return element.data;
    }

    let text = '';
    let prev: any = null;

    for ( const child of element.getChildren() ) {
      const childText = this.modelElementToPlainText( child );
      if ( prev && prev.is( 'element' ) ) {
        text += '\n';
      }

      text += childText;

      prev = child;
    }

    return text;
  }
}
