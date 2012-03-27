package utils {
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * Класс анимирует вылетание бонусов из чего-нибудь.
	 * Чтобы использовать, нужно добавить на stage BeenzaBouncer.instance, а затем вызывать BeenzaBouncer.bounceObject().
	 * 
	 * @author kutu
	 */	
	public class BeenzaBouncer extends Sprite {
		
		private static const ICON_GLOW:GlowFilter = new GlowFilter(0xFFFFFF, 1, 4, 4, 8, 1, false, false);
		private static const ICON_ROLLOVER_GLOW:GlowFilter = new GlowFilter(0xF5E556, 1, 4, 4, 8, 1, false, false);
		private static const ICON_DROPSHADOW:DropShadowFilter = new DropShadowFilter(2, 45, 0, 0.2, 0, 0, 4, 1, false, false, false);
		private static const TXT_GLOW:GlowFilter = new GlowFilter(0xFFFFFF, 1, 4, 4, 8, 1, false, false);
		
		private static var _instance:BeenzaBouncer;
		
		private var vos:Vector.<BounceVO>;
		
		public static function get instance():BeenzaBouncer {
			if (!_instance) {
				_instance = new BeenzaBouncer();
				_instance.mouseEnabled = false;
			}
			return _instance;
		}
		
		/**
		 * Функция, которая принимает изображение иконки и другие параметры, чтобы анимировать вылетающий бонус из чего-нибудь.
		 * 
		 * @param obj собственно иконка, которая будет вылетать
		 * @param bonusType тип бонуса
		 * @param number число которое будет вылетать из иконки при скликивании или по таймауту
		 * @param text текст который прибавляется к строке вылетающего числа
		 * @param srcSprite источник, из какого как бы спрайта будет вылетать иконка
		 * @param srcPoint относительная точка внутри спрайта, откуда будет стартовать анимация иконки
		 * @param dstPoint точка, куда прилетит иконка и будет ждать скликивания или таймаута, в глобальных координатах
		 * @param txtFormat формат текста, который вылетает из иконки бонуса
		 * @param outPoint точка, куда улетит иконка при скикивании или по таймауту, в глобальных координатах
		 * @param timeout сосбственно таймаут, если пользователь сам не скликнет, то иконка улетит в outPoint через n секунд
		 * @param bounceSound звук, проигрывающийся в момент вылета иконки
		 * @param startDelay задержка перед стартом вылета иконки, в секундах
		 * @param complete необязательная колбэк функция, которая вызовется, когда иконка начнет полет в outPoint
		 */

		public static function bounceObject(obj:Sprite, bonusType:uint, number:uint, text:String, srcSprite:Sprite, srcPoint:Point, dstPoint:Point, txtFormat:TextFormat, outPoint:Point, bounceSound:Class, timeout:Number, startDelay:Number = 0, complete:Function=null):void {
			if (!instance.vos) {
				instance.vos = new Vector.<BounceVO>();
			}
			const vo:BounceVO = new BounceVO(obj, bonusType, number, text, outPoint, txtFormat, timeout, complete)
			instance.vos.push(vo); 
			
			//obj.addEventListener(MouseEvent.ROLL_OVER, instance.onExperienceRollOver);
			//obj.addEventListener(MouseEvent.ROLL_OUT, instance.onExperienceRollOut);
			//obj.addEventListener(MouseEvent.MOUSE_DOWN, instance.onExperienceMouseDown);
			

			// стартовая точка, откуда полетит иконка в глобальных координатах
			const startPoint:Point = srcPoint;
			obj.x = int(startPoint.x + .5);
			obj.y = int(startPoint.y + .5);
			obj.alpha = .5;
			obj.useHandCursor = false;
			obj.buttonMode = false;
			obj.filters = [ICON_GLOW, ICON_DROPSHADOW];
			
			// смещаем точку приземления иконки относительно стартовой
			dstPoint = dstPoint.add(startPoint);
			
			// летим на рандомную высоту
			const randHeight:int = Math.min(obj.y, dstPoint.y) - (30 + Math.random() * 30);
			// анимируем икноку по линии безье в dstPoint, по окончании ждем таймаут если пользователь сам не скликнет бонус
			TweenMax.to(obj, .4, {
				bezierThrough:[
					{x:obj.x + dstPoint.x >> 1, y:randHeight},
					{x:dstPoint.x, y:dstPoint.y}
				],
				alpha:1, delay:startDelay, roundProps:["x", "y"], ease:Linear.easeNone,
				onStart:function(obj:Sprite):void {
					instance.addChild(obj);
					//SoundsManager.playSoundByName(bounceSound);
				}, onStartParams:[obj]//,
				//onComplete:function(vo:BounceVO):void {
				//	vo.timeoutId = setTimeout(instance.click, vo.timeout * 1000, vo.obj);
				//},
				//onCompleteParams:[vo]
			});
		}
		
		public function createBounceTextField(string:String, txtFormat:TextFormat):TextField {
			const txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			//txt.embedFonts = true;
			txt.selectable = false;
			txt.mouseEnabled = false;
			txt.defaultTextFormat = txtFormat;
			txt.text = string;
			txt.filters = [TXT_GLOW];
			return txt;
		}
		
		public function bounceTxtAtPoint(txt:TextField, point:Point, delayTime:Number = 0, duration:Number = 1):void {
			txt.x = point.x;
			txt.y = point.y;
			if (stage) {
				trace("shot text from bounce : " + txt.text + " [BeenzaBouncer.bounceTxtAtPoint]");
				instance.addChild(txt);

				TweenMax.to(txt, duration, {y:txt.y-90, delay:delayTime,
					onComplete:disappearTxt, onCompleteParams:[txt],
					ease: Cubic.easeOut
				});
			}
		}
		
		private function disappearTxt(txt:TextField):void {
			TweenMax.to(txt, 0.3, {alpha: 0,
				onComplete:function(txt:TextField):void {
					if (instance.contains(txt)) instance.removeChild(txt);
				}, onCompleteParams:[txt]
			})
		}
		
		// создает текстовое поле которое вылетает при скликивании или по таймауту из иконки
		public function createTxt(obj:Sprite, number:uint, text:String, txtFormat:TextFormat, bonusType:uint = NaN,
								outPoint:Point = null, prefix:String = "", 
								delayTime:Number = 0, duration:Number = 1):void {

			const string:String = prefix + number.toString() + text;
			var _x:Number;
			var _y:Number;
			// тут определяем, если пользователь скликнул, значит анимация стартует из точки скликивания, иначе из центра иконки
			const txt:TextField = createBounceTextField(string, txtFormat);
			if (obj.hitTestPoint(mouseX, mouseY)) {
				_x = mouseX - (txt.width >> 1);
				_y = mouseY - txt.height;
			} else {
				_x = obj.x + (obj.width - txt.width >> 1);
				_y = obj.y + (obj.height - txt.height >> 1);
			}
			bounceTxtAtPoint(txt, new Point(_x, _y),delayTime, duration);
		}

		/*
		
		private function onExperienceRollOver(event:MouseEvent):void {
			const obj:Sprite = event.target as Sprite;
			obj.filters = [ICON_ROLLOVER_GLOW, ICON_DROPSHADOW];
		}
		private function onExperienceRollOut(event:MouseEvent):void {
			const obj:Sprite = event.target as Sprite;
			obj.filters = [ICON_GLOW, ICON_DROPSHADOW];
		}
		
		private function onExperienceMouseDown(event:MouseEvent):void {
			event.stopImmediatePropagation();
			const obj:Sprite = event.target as Sprite;
			click(obj);
		}
		
		// скликивание, либо пользователем, либо по таймауту
		private function click(obj:Sprite):void {
			if (obj == null) {return}
			obj.removeEventListener(MouseEvent.ROLL_OVER, onExperienceRollOver);
			obj.removeEventListener(MouseEvent.ROLL_OUT, onExperienceRollOut);
			const vo:BounceVO = getBouncerVOByObj(obj);
			if (!vo) return;
			
			TweenMax.to(vo.obj, 1, {x:globalToLocal(vo.out).x, y:globalToLocal(vo.out).y, ease:Circ.easeOut, 
				roundProps:["x", "y"], alpha:0, delay:0, onComplete:function(obj:Sprite):void {
					if (instance.contains(obj)) instance.removeChild(obj);
				}, onCompleteParams:[obj]
			});
			
			createTxt(vo.obj, vo.number, vo.text, vo.txtFormat, vo.bonusType, vo.out, "+");
			SoundsManager.playSoundByName(Sounds.BONUS_FLY);
			
			// подсвечиваем нужный виджет при скликивании
			switch (vo.bonusType) {
				case 0:
					BarUserInterface.instance.levelIndicator.tinting();
					break;
				case 1:
					BarUserInterface.instance.moneyIndicator.tinting();
					break;
				case 2:
					BarUserInterface.instance.energyIndicator.tinting();
					break;
			}
			
			if (vo.complete != null) {
				vo.complete(obj);
				vo.complete = null;
			}
			
			vo.obj = null;
			vo.out = null;
			clearTimeout(vo.timeoutId);
			
			vos.splice(vos.indexOf(vo), 1);
		}
		
		// находит наш валуе обжект в векторе по иконке
		private function getBouncerVOByObj(obj:Sprite):BounceVO {
			for each (var vo:BounceVO in vos) {
				if (vo.obj == obj) {
					return vo;
				}
			}
			return null;
		}
	*/
	}

	
}

import flash.display.Sprite;
import flash.geom.Point;
import flash.text.TextFormat;

class BounceVO {
	
	public var obj:Sprite;
	public var bonusType:uint;
	public var number:uint;
	public var text:String;
	public var out:Point;
	public var txtFormat:TextFormat;
	public var timeout:Number;
	public var complete:Function;
	public var timeoutId:uint;
	
	public function BounceVO(obj:Sprite, bonusType:uint, number:uint, text:String, out:Point, txtFormat:TextFormat, timeout:Number, complete:Function) {
		this.obj = obj;
		this.bonusType = bonusType;
		this.number = number;
		this.text = text;
		this.out = out;
		this.txtFormat = txtFormat;
		this.timeout = timeout;
		this.complete = complete;
	}
	
}
