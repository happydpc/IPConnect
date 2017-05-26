import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import api.ui.ipconnect 2.0

Item { id: item

	property string theme: "crimson"
	property string textColor: "#333"
	property string bgColor: "#f7f7f7"
	FontLoader { id: awesome; source: "qrc:/resources/fontawesome-webfont.ttf" }

	Item { id: messageBox
		height: parent.height
		anchors.left: parent.left
		anchors.right: userListBox.left

		Rectangle { id: msgViewBox
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			anchors.bottom: msgInputBox.top
			color: "#f9f9f9"
			anchors.bottomMargin: 20
			anchors.rightMargin: 20
			clip: true

			Component { id: msgDelegate

				Rectangle { id: msgWrapper
					color: sent ? item.theme : "#fdfdfd"
					border.width: 1
					border.color: "#10000000"
					anchors.margins: 5
					height: userNameItem.height + messageItem.height
					width: userNameItem.width > messageItem.width ? userNameItem.width : messageItem.width

					Component.onCompleted: {
						if(sent)
							anchors.right = parent.right
						else
							anchors.left = parent.left
					}

					Item { id:userNameItem
						anchors.top: parent.top
						anchors.left: parent.left
						height: userName.height + 20
						width: userName.width + 20
						clip: true

						Text { id: userName
							anchors.verticalCenter: parent.verticalCenter
							x: 10
							width: implicitWidth > msgViewBox.width*2/3 ? msgViewBox.width*2/3 : implicitWidth
							text: (sent? "To : " : "From : ") + "<b>" + user + "</b>"
							color: sent? "#fdfdfd" : "#333"
							font.pixelSize: 12
							wrapMode: Text.Wrap
						}
					}

					Item { id:messageItem
						anchors.top: userNameItem.bottom
						anchors.left: parent.left
						height: msgbody.height + 20
						width: msgbody.width + 20
						clip: true

						Text {
							id: msgbody
							anchors.verticalCenter: parent.verticalCenter
							x: 10
							width: implicitWidth > msgViewBox.width*2/3 ? msgViewBox.width*2/3 : implicitWidth
							text: message
							wrapMode: Text.Wrap
							color: sent? "#fdfdfd" : "#333"
							font.pixelSize: 16
						}
					}
				}
			}

			ScrollView {
				anchors.fill: parent
				flickableItem.interactive: true

				style: ScrollViewStyle {
					transientScrollBars: true
					handle: Item {
						implicitWidth: 14
						implicitHeight: 26
						Rectangle {
							color: "#50000000"
							anchors.fill: parent
							anchors.margins: 4
							radius: 4
						}
					}
				}

				ListView { id:msgView
					anchors.fill: parent
					anchors.topMargin: 5
					delegate: msgDelegate
					model: IPConnect.messages//_messages//msgModel
					spacing: 5
				}
			}

			ListModel { id: msgModel
				ListElement{user:"Shyam";msg:"Hi How are you ? Hi How are you ? Hi How are you ? Hi How are you ? Hi How are you ? Hi How are you ? Hi How are you ? Hi How are you ? Hi How are you ? Hi How are you ?Hi How are you ?";sent:true}
				ListElement{user:"Shyam";msg:"I am Great, How are you ? ";sent:false}
				ListElement{user:"Shyam";msg:"fine thanks";sent:true}
				ListElement{user:"Shyam";msg:"How's College ? How's College ? How's College ? How's College ? How's College ? How's College ? How's College ? How's College ? How's College ? ";sent:true}
				ListElement{user:"Shyam";msg:"Good ";sent:false}
				ListElement{user:"Shyam";msg:"which year are you in ?";sent:true}
				ListElement{user:"Shyam";msg:"Pre Final Year";sent:false}
				ListElement{user:"Shyam";msg:"Going Great ? ";sent:true}
				ListElement{user:"Shyam";msg:"Awesome";sent:false}
				ListElement{user:"Shyam";msg:"Alright See You Soon";sent:true}
			}
		}

		DropShadow { id: dropMsgViewBox
			anchors.fill: msgViewBox
			source: msgViewBox
			horizontalOffset: 0
			verticalOffset: 0
			radius: 7
			samples: 32
			color: "#20000000"
			transparentBorder: true
		}

		Rectangle { id:msgInputBox
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			height: 40
			anchors.topMargin: 20
			anchors.rightMargin: 20
			color: "#f9f9f9"

			TextField { id:msgInput
				height: parent.height
				anchors.left: parent.left
				anchors.right: sendBtn.left
				font.pixelSize: 14

				style: TextFieldStyle {
					background: Rectangle{
						id:msgInputStyle
						color:"transparent"
					}
				}

				onAccepted:{
					if(userList.currentIndex >= 0)
					{
						IPConnect.sendMessage(userList.currentItem.idno,text);
						text = ""
					}
				}

				onFocusChanged: {
					if(activeFocus)
					{
						dropMsgInputBox.radius = 16
						msgInputBox.color = "#fff"
					}
				}
			}

			Rectangle { id: sendBtn
				width: parent.height
				height: parent.height
				anchors.right: parent.right
				color: item.bgColor

				Text { id: sendBtnImage
					font.family: awesome.name
					font.pixelSize: 24
					text: "\uf1d8"
					color: item.theme
					anchors.centerIn: parent
				}

				MouseArea{
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: {
						if(userList.currentIndex >= 0)
						{
							_messenger.sendMessage(userList.currentItem.idno,msgInput.text);
							msgInput.text = ""
						}
					}
				}
			}
		}

		DropShadow { id: dropMsgInputBox
			anchors.fill: msgInputBox
			source: msgInputBox
			horizontalOffset: 0
			verticalOffset: 0
			radius: 7
			samples: 32
			color: "#20000000"
			transparentBorder: true
		}
	}

	Rectangle { id:userListBox
		height: parent.height
		anchors.right: parent.right
		anchors.leftMargin: 20
		width: 250
		color: "#f9f9f9"
		clip: true

		Component { id: userDelegate

			Item { id: wrapper
				width: parent.width
				height: 40

				property int idno : id

				Item { id:status
					width: parent.height
					height: parent.height
					visible: false

					Rectangle { id: statusLight
						height: parent.height/5
						width: parent.width/5
						anchors.centerIn: parent
						color: item.theme
						radius: width*0.5
					}
				}

				Text { id: user
					anchors.left: status.right
					anchors.right: parent.right
					anchors.verticalCenter: parent.verticalCenter
					text: name
					color: "#666"
				}

				states: State {
					name: "Current"
					when: wrapper.ListView.isCurrentItem
					PropertyChanges { target: status; visible: true }
					PropertyChanges { target: user; color: item.theme }
				}
				transitions: Transition {
					NumberAnimation { properties: "visible"; duration: 50 }
				}
				MouseArea {
					anchors.fill: parent
					onClicked: wrapper.ListView.view.currentIndex = index
				}
			}
		}

		Component { id: highlightBar

			Rectangle{
				width: userList.width;
				height: 40
				y: userList.currentItem.y;
				Behavior on y { NumberAnimation { duration: 50 } }
				color: "#fff"
			}
		}

		ScrollView{
			anchors.fill: parent
			flickableItem.interactive: true

			style: ScrollViewStyle {
				transientScrollBars: true
				handle: Item {
					implicitWidth: 14
					implicitHeight: 26
					Rectangle {
						color: "#50000000"
						anchors.fill: parent
						anchors.margins: 4
						radius: 4
					}
				}
			}

			ListView { id:userList
				anchors.fill: parent
				model: IPConnect.users//_users
				delegate: userDelegate
				highlight: highlightBar
				highlightFollowsCurrentItem: false
			}
		}
	}

	DropShadow { id: dropUserListBox
		anchors.fill: userListBox
		source: userListBox
		horizontalOffset: 0
		verticalOffset: 0
		radius: 7
		samples: 32
		color: "#20000000"
		transparentBorder: true
	}
}